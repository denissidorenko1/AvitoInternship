import Foundation

struct GetProductRequest: NetworkRequest {
    let offset: Int
    let limit: Int
    var endPoint: URL? { Endpoint.products(offset: offset, limit: limit).url }
    var httpMethod: HTTPMethod = .get
}
