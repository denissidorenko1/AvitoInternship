import Foundation
import SwiftUI

final class SearchScreenViewModel: ObservableObject {
    // MARK: - ViewState
    enum ViewState {
        case loading, loaded, error, empty, options
    }

    // MARK: - Dependencies
    private let repository: SearchRepositoryProtocol
    private let shoppingListManager: ShoppingListManagerProtocol
    private let networkModel: NetworkSearchModelProtocol
    
    // MARK: - Published Properties
    @Published var viewState: ViewState = .loading
    @Published var filterState = FilterState()
    @Published var productList: [ProductModel] = []
    @Published var latestQueries: [LastQuery] = []
    @Published var shoppingList: [BucketListItem] = []
    @Published var categories: [Category] = []
    @Published var currentCategory: Category?
    @Published var selectedItem: ProductModel?
    @Published var isShowingBucket: Bool = false
    @Published var isViewPresented: Bool = false {
        didSet {
            if !isViewPresented {
                selectedItem = nil
            }
        }
    }

    // MARK: - Private Properties
    private let loadLimit = 10
    
    // MARK: - Computed Properties
    var totalPrice: Int {
        shoppingListManager.totalPrice
    }

    // MARK: - Initializer
    init(repository: SearchRepositoryProtocol = SearchRepository(),
         shoppingListManager: ShoppingListManagerProtocol = ShoppingListManager(),
         networkModel: NetworkSearchModelProtocol = NetworkSearchModel()) {
        self.repository = repository
        self.shoppingListManager = ShoppingListManager()
        self.networkModel = networkModel
    }
    
    // MARK: - Public Properties
    // MARK: Data Fetching
    func fetchRecentQueries() {
        latestQueries = repository.fetchRecentQueries()
    }
    
    func saveNewQuery() {
        repository.saveQuery(
            LastQuery(
                text: filterState.title,
                date: .now,
                priceMin: filterState.priceMin,
                priceMax: filterState.priceMax,
                categoryId: filterState.currentCategoryId,
                categoryName: currentCategory?.name
            )
        )
    }
    
    func fetchProducts() {
        Task {
            await MainActor.run { viewState = .loading }
            do {
                if filterState.hasChanges { productList = [] }
                
                let products = try await networkModel.fetchProducts(
                    title: filterState.title,
                    categoryId: filterState.currentCategoryId,
                    priceMin: filterState.priceMin,
                    priceMax: filterState.priceMax,
                    offset: productList.count,
                    limit: loadLimit
                )
                
                await MainActor.run {
                    filterState.hasChanges = false
                    productList = products
                    viewState = products.isEmpty ? .empty : .loaded
                }
            } catch {
                await MainActor.run { viewState = .error }
            }
        }
    }
    
    func loadNewPage() {
        Task {
            do {
                let products = try await networkModel.fetchProducts(
                    title: filterState.title,
                    categoryId: filterState.currentCategoryId,
                    priceMin: filterState.priceMin,
                    priceMax: filterState.priceMax,
                    offset: productList.count,
                    limit: loadLimit
                )
                await MainActor.run {
                    productList.append(contentsOf: products)
                }
            } catch {
                viewState = .error
            }
        }
    }
    
    func fetchCategories() {
        Task {
            do {
                categories = try await networkModel.fetchCategories()
            } catch {
                print(error)
            }
        }
    }

    // MARK: Search & Filters
    func didSelectCategory(_ category: Category) {
        filterState.currentCategory = category
        filterState.currentCategoryId = category.id
    }
    
    func clearFilter() {
        filterState.reset()
        fetchProducts()
    }

    func clearCurrentCategory() {
        filterState.currentCategory = nil
        filterState.currentCategoryId = nil
    }

    func fetchFromRecentQuery(with query: LastQuery) {
        filterState.update(from: query)
        fetchProducts()
    }

    // MARK: Shopping List Management
    func incrementProduct(_ product: ProductModel) {
        shoppingListManager.incrementProduct(product)
        loadShoppingList()
    }
    
    func decrementProduct(_ product: ProductModel) {
        shoppingListManager.decrementProduct(product)
        loadShoppingList()
    }
    
    func incrementQuantity(for item: BucketListItem) {
        shoppingListManager.incrementQuantity(for: item)
        loadShoppingList()
    }
    
    func decrementQuantity(for item: BucketListItem) {
        shoppingListManager.decrementQuantity(for: item)
        loadShoppingList()
    }
    
    func loadShoppingList() {
        shoppingList = shoppingListManager.loadPurchaseList()
    }
    
    
    // MARK: - Navigation Handling
    func didTapItem(_ item: ProductModel) {
        selectedItem = item
        isViewPresented = true
    }
    
    func showBucket() {
        isShowingBucket = true
    }
}
