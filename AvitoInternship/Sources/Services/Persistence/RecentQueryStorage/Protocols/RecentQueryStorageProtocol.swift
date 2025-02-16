import Foundation

// MARK: - RecentQueryStorageProtocol
protocol RecentQueryStorageProtocol {
    func save(_ query: LastQuery) -> [LastQuery]
    func load() -> [LastQuery]
}
