import Foundation
import Combine


// MARK: - ShoppingListStorage
final class ShoppingListStorage: ShoppingListStorageProtocol {
    // MARK: - Dependencies
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: Static Properties
    static let shared = ShoppingListStorage()
    
    // MARK: - Public Properties
    let operationCompletion = PassthroughSubject<Void, Never>()
    
    // MARK: - Private  Properties
    private var key: String = "ShoppingListStorage"
    
    // MARK: - Public Methods
    func save(shoppingList: [Item]) {
        if let encoded = try? encoder.encode(shoppingList) {
            defaults.set(encoded, forKey: key)
            operationCompletion.send()
        }
    }
    
    func load() -> [Item] {
        if let queryModel = defaults.object(forKey: key) as? Data {
            if let decoded = try? decoder.decode([BucketListItem].self, from: queryModel) {
                return decoded
            }
        }
        return []
    }
    
}
