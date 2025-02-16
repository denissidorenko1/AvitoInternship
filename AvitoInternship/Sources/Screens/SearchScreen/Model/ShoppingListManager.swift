import Foundation
import Combine

// MARK: ShoppingListManagerProtocol
protocol ShoppingListManagerProtocol {
    var purchaseList: [BucketListItem] { get } 
    var totalPrice: Int { get }
    
    func loadPurchaseList() -> [BucketListItem]
    func incrementProduct(_ product: ProductModel)
    func decrementProduct(_ product: ProductModel)
    func incrementQuantity(for item: BucketListItem)
    func decrementQuantity(for item: BucketListItem)
    func clearList()
}

// MARK: ShoppingListManager
final class ShoppingListManager: ShoppingListManagerProtocol {
    
    var purchaseList: [BucketListItem] = []
    
    private let storageService = ShoppingListStorage.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        storageService.operationCompletion
            .sink { [weak self] _ in
                self?.loadPurchaseList()
            }
            .store(in: &cancellables)
    }
    
    var totalPrice: Int {
        purchaseList.map { $0.quantity * $0.item.price }.reduce(0, +)
    }
    
    @discardableResult
    func loadPurchaseList() -> [BucketListItem] {
        purchaseList = storageService.load()
        return purchaseList
    }

    func incrementProduct(_ product: ProductModel) {
        if let index = purchaseList.firstIndex(where: { $0.item.id == product.id }) {
            purchaseList[index].quantity += 1
        } else {
            purchaseList.append(BucketListItem(item: product, quantity: 1))
        }
        saveList()
    }
    
    func decrementProduct(_ product: ProductModel) {
        let firstIndex = purchaseList.firstIndex { purchaseListItem in
            purchaseListItem.item.id == product.id
        }
        
        if let firstIndex {
            decrementQuantity(for: purchaseList[firstIndex])
        }
    }


    func incrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item) {
            purchaseList[index].quantity += 1
            saveList()
        }
    }
    
    func decrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item), item.quantity > 0 {
            purchaseList[index].quantity -= 1
            if purchaseList[index].quantity == 0 {
                purchaseList.remove(at: index)
            }
            saveList()
        }
    }
    
    func clearList() {
        purchaseList = []
        saveList()
    }
    
    private func saveList() {
        storageService.save(shoppingList: purchaseList)
    }
}
