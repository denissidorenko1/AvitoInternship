import Foundation

// MARK: SearchRepositoryProtocol
protocol SearchRepositoryProtocol {
    func fetchRecentQueries() -> [LastQuery]
    
    func saveQuery(_ query: LastQuery)
}

// MARK: SearchRepository
final class SearchRepository: SearchRepositoryProtocol {
    private let queryService = RecentQueryService.shared

    func fetchRecentQueries() -> [LastQuery] {
        return queryService.load()
    }

    func saveQuery(_ query: LastQuery) {
        _ = queryService.save(query)
    }
}
