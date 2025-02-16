import Foundation

struct GetCategoryRequest: NetworkRequest {
    var endPoint: URL? { Endpoint.categories.url }
    var httpMethod: HTTPMethod = .get
}
