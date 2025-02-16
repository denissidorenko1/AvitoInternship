import Foundation

// MARK: - RecentQueryService
final class RecentQueryService: RecentQueryStorageProtocol {
    // MARK: - Dependencies
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Initializer
    init(maxCount: Int = 5) {
        self.maxCount = maxCount
    }
    
    // MARK: - Static Properties
    static let shared = RecentQueryService()
    
    // MARK: - Private Properties
    private var maxCount: Int
    private var key: String = "RecentQueryServiceKey"
    
    
    // MARK: - Public Methods
    func save(_ query: LastQuery) -> [LastQuery] {
        var currentQueries = load()
        currentQueries.insert(query, at: 0)
        if currentQueries.count > maxCount {
            currentQueries.removeLast()
        }
        if let encoded = try? encoder.encode(QueryStorageModel(queries: currentQueries)) {
            defaults.set(encoded, forKey: key)
        }
        return currentQueries
    }
    
    func load() -> [LastQuery] {
        if let queryModel = defaults.object(forKey: key) as? Data {
            if let decoded = try? decoder.decode(QueryStorageModel.self, from: queryModel) {
                return decoded.queries.sorted(by: >)
            }
        }
        return []
    }
}

