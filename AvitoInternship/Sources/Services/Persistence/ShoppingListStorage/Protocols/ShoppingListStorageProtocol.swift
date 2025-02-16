import Foundation

// MARK: - ShoppingListStorageProtocol
protocol ShoppingListStorageProtocol {
    typealias Item = BucketListItem
    
    func save(shoppingList: [Item])
    func load() -> [Item]
}
