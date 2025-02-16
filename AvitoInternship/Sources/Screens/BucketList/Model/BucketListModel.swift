import Foundation
import Combine

protocol BucketListModelProtocol {
    func loadPurchaseList() -> [BucketListItem]
    func incrementQuantity(for item: BucketListItem)
    func decrementQuantity(for item: BucketListItem)
    func deleteAllItems()
}

final class BucketListModel: BucketListModelProtocol {
    // MARK: - Dependencies
    private let storageService = ShoppingListStorage.shared
    private var purchaseList: [BucketListItem] = []

    // MARK: - Load Items
    func loadPurchaseList() -> [BucketListItem] {
        purchaseList = storageService.load()
        return purchaseList
    }

    // MARK: - Modify Items
    func incrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(where: { $0.item.id == item.item.id }) {
            purchaseList[index].quantity += 1
        } else {
            purchaseList.append(BucketListItem(item: item.item, quantity: 1))
        }
        saveList()
    }

    func decrementQuantity(for item: BucketListItem) {
        if let index = purchaseList.firstIndex(where: { $0.item.id == item.item.id }) {
            if purchaseList[index].quantity > 1 {
                purchaseList[index].quantity -= 1
            } else {
                purchaseList.remove(at: index)
            }
        }
        saveList()
    }

    func deleteAllItems() {
        purchaseList.removeAll()
        saveList()
    }

    // MARK: - Save
    private func saveList() {
        storageService.save(shoppingList: purchaseList)
    }
}

