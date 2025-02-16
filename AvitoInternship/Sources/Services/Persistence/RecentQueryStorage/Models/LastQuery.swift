import Foundation

// MARK: - LastQuery
struct LastQuery {
    let text: String?
    let date: Date
    let priceMin: Int?
    let priceMax: Int?
    let categoryId: Int?
    let categoryName: String?
}
// MARK: - LastQuery Comparable Extension
extension LastQuery: Comparable {
    static func < (lhs: LastQuery, rhs: LastQuery) -> Bool {
        lhs.date < rhs.date
    }
}

// MARK: - LastQuery Codable Extension
extension LastQuery: Codable {
    
}
