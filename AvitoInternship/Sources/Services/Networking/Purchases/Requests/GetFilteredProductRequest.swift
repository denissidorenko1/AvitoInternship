import Foundation

struct GetFilteredProductRequest: NetworkRequest {
    let title: String?
    let categoryId: Int?
    let priceMin: Int?
    let priceMax: Int?
    let price: Int?
    let offset: Int
    let limit: Int
    var endPoint: URL? { Endpoint.filteredProducts(title: title, categoryId: categoryId, priceMin: priceMin, priceMax: priceMax, price: price, offset: offset, limit: limit).url }
    var httpMethod: HTTPMethod = .get
}
