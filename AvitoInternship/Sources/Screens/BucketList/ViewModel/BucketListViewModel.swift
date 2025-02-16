
import Foundation
import SwiftUI
import Combine

//@MainActor

//MARK: - BucketListViewModel
final class BucketListViewModel: ObservableObject {
    // MARK: - Dependencies
    private var purchaseStorageService = ShoppingListStorage.shared
    
    // MARK: - Initializer
    init(itemList: [BucketListItem]) {
        self.itemList = itemList
        purchaseStorageService.operationCompletion
            .sink { [weak self] _ in
                self?.loadPurchaseList()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Published Properties
    @Published var itemList: [BucketListItem]
    @Published var selectedItem: ProductModel?
    @Published var isViewPresented: Bool = false {
        didSet {
            if !isViewPresented {
                selectedItem = nil
            }
        }
    }
    
    // MARK: - Computed Properties
    var purchaseListDescription: String {
        itemList.map { "\($0.quantity) x \($0.item.title)" }.joined(separator: "\n")
    }
    
    var totalPrice: Int {
        itemList.map { $0.quantity * $0.item.price}.reduce(0, +)
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    func showProductView(with item: ProductModel) {
        selectedItem = item
        isViewPresented = true
    }
    
    func incrementQuantity(for item: BucketListItem) {
        if let index = itemList.firstIndex(of: item) {
            itemList[index].quantity += 1
            savePurchaseList()
        }
    }
    
    func decrementQuantity(for item: BucketListItem) {
        if let index = itemList.firstIndex(of: item), item.quantity > 0 {
            itemList[index].quantity -= 1
            if itemList[index].quantity == 0 {
                itemList.remove(at: index)
            }
            savePurchaseList()
        }
    }
    
    // TODO: - метод не используется, дописать имплементацию или удалить
    func moveItems(from source: IndexSet, to destination: Int) {
        itemList.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteAllItems() {
        itemList.removeAll()
        savePurchaseList()
    }
    
    func loadPurchaseList() {
        itemList = purchaseStorageService.load()
    }
    
    // MARK: - Private Properties
    private func savePurchaseList() {
        purchaseStorageService.save(shoppingList: itemList)
    }
    
}
