import Foundation

// MARK: - BucketListItem
struct BucketListItem {
    let item: ProductModel
    var quantity: Int
}

// MARK: - BucketListItem Equatable Extension
extension BucketListItem: Equatable {
    static func == (lhs: BucketListItem, rhs: BucketListItem) -> Bool {
        return lhs.item.id == rhs.item.id && lhs.quantity == rhs.quantity
    }
}

// MARK: - BucketListItem Codable Extension
extension BucketListItem: Codable {
    
}
