import Foundation
import Combine

// MARK: - SearchScreenViewModel
final class SearchScreenViewModel: ObservableObject {
    // MARK: - ViewState
    enum ViewState {
        case loading
        case loaded
        case error
        case empty
        case options
    }
    
    // MARK: Dependencies
    private let networkingService = NetworkingService.shared
    private let queryService = RecentQueryService.shared
    private let purchaseStorageService = ShoppingListStorage.shared
    
    // MARK: - Initializer
    init() {
        purchaseStorageService.operationCompletion
            .sink { [weak self] _ in
                self?.loadPurchaseList()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Published Properties
    @Published var viewState : ViewState = .loading
    @Published var title: String? = "" { didSet { hasChanges = true }}
    @Published var priceMin: String? = "" { didSet { hasChanges = true }}
    @Published var priceMax: String? = "" { didSet { hasChanges = true }}
    @Published var currentCategory: Category? { didSet { hasChanges = true }}
    @Published var currentCategoryId: Int? { didSet { hasChanges = true }}
    
    @Published var productList: [ProductModel] = []
    @Published var latestQueries: [LastQuery] = []
    @Published var categories: [Category] = []
    @Published var purchaseList: [BucketListItem] = []
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
    private var hasChanges: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var loadLimit: Int = 10
    
    // MARK: - Computed Properties
    var totalPrice: Int { purchaseList.map { $0.quantity * $0.item.price}.reduce(0, +) }
    
    // MARK: - Public Methods
    func fetchRecentQueries() {
        latestQueries = queryService.load()
    }
    
    func saveQuery() {
        let _ = queryService.save(
            LastQuery(
                text: title,
                date: .now,
                priceMin: priceMin == nil ? nil : Int(priceMin!),
                priceMax: priceMax == nil ? nil : Int(priceMax!),
                categoryId: currentCategoryId,
                categoryName: currentCategory?.name
            )
        )
    }
    
    func didSelectCategory(_ category: Category) {
        currentCategory = category
        currentCategoryId = category.id
    }
    
    func clearFilter() {
        title = nil
        priceMin = nil
        priceMax = nil
        currentCategory = nil
        currentCategoryId = nil
        purchaseList = []
        hasChanges = true
        
        fetchProducts()
    }
    
    func clearCurrentCategory() {
        currentCategory = nil
        currentCategoryId = nil
        hasChanges = true
    }
    
    func fetchFromRecentQuery(with queryItem: LastQuery) {
        title = queryItem.text
        priceMin = queryItem.priceMin == nil ? nil : String(queryItem.priceMin!)
        priceMax = queryItem.priceMax == nil ? nil : String(queryItem.priceMax!)
        currentCategoryId = queryItem.categoryId
        
        fetchProducts()
    }
    
    func loadNewPage() {
        Task {
            do {
                let products = try await networkingService.getFilteredProductList(
                    title: title,
                    categoryId: currentCategoryId,
                    priceMin: priceMin == nil ? nil : Int(priceMin!),
                    priceMax: priceMax == nil ? nil : Int(priceMax!),
                    price: nil,
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
    
    func fetchProducts() {
        Task {
            await MainActor.run {
                viewState = .loading
            }
            do {
                if hasChanges { productList = []}
                
                let products = try await networkingService.getFilteredProductList(
                    title: title,
                    categoryId: currentCategoryId,
                    priceMin: priceMin == nil ? nil : Int(priceMin!),
                    priceMax: priceMax == nil ? nil : Int(priceMax!),
                    price: nil,
                    offset: productList.count,
                    limit: loadLimit
                )
                await MainActor.run {
                    hasChanges = false
                    if products.count == 0 {
                        productList = products
                        viewState = .empty
                    } else {
                        productList.append(contentsOf: products)
                        viewState = .loaded
                    }
                }
            } catch {
                viewState = .error
            }
        }
    }
    
    func loadPurchaseList() {
        purchaseList = purchaseStorageService.load()
    }
    
    func incrementQuantity(for productModel: ProductModel) {
        let firstIndex = purchaseList.firstIndex { BucketListItem in
            BucketListItem.item.id == productModel.id
        }
        
        if let firstIndex {
            incrementQuantity(for: purchaseList[firstIndex])
        } else {
            purchaseList.append(
                BucketListItem(item: productModel, quantity: 1)
            )
            savePurchaseList()
        }
    }
    
    func decrementQuantity(for productModel: ProductModel) {
        let firstIndex = purchaseList.firstIndex { BucketListItem in
            BucketListItem.item.id == productModel.id
        }
        
        if let firstIndex {
            decrementQuantity(for: purchaseList[firstIndex])
        }
    }
    
    func fetchCategories() {
        Task {
            do {
                categories = try await networkingService.getCategoryList()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func incrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item) {
            purchaseList[index].quantity += 1
            savePurchaseList()
        }
    }
    
    private func decrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item), item.quantity > 0 {
            purchaseList[index].quantity -= 1
            if purchaseList[index].quantity == 0 {
                purchaseList.remove(at: index)
            }
            savePurchaseList()
        }
    }
    
    private func savePurchaseList() {
        purchaseStorageService.save(shoppingList: purchaseList)
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
