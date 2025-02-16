import Foundation
// FIXME: - покрыть протоколом

// MARK: - ItemCardModelProtocol
protocol ItemCardModelProtocol {
    
}

// MARK: - ItemCardModel
final class ItemCardModel: ItemCardModelProtocol {
    // MARK: - Dependencies
    
    private let storageService = ShoppingListStorage.shared
    // MARK: - Private Properties
    private var purchaseList: [BucketListItem] = []
    
    func getCurrentItemCount(with item: ProductModel) -> Int {
        loadPurchaseList()
        
        if let index = purchaseList.firstIndex(where: { $0.item.id == item.id }) {
            return purchaseList[index].quantity
        } else {
            return 0
        }
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
    
    private func incrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item) {
            purchaseList[index].quantity += 1
            saveList()
        }
    }
    
    private func decrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(of: item), item.quantity > 0 {
            purchaseList[index].quantity -= 1
            if purchaseList[index].quantity == 0 {
                purchaseList.remove(at: index)
            }
            saveList()
        }
    }
    
    private func saveList() {
        storageService.save(shoppingList: purchaseList)
        loadPurchaseList()
    }
}
