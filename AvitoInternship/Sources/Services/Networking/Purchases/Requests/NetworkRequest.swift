import Foundation

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get
    
    var name: String {
        return rawValue.uppercased()
    }
}

// MARK: - NetworkRequest protocol
protocol NetworkRequest: Sendable {
    var endPoint: URL? { get }
    var httpMethod: HTTPMethod { get }
    var dto: Encodable? { get }
}

// MARK: - NetworkRequest extension
extension NetworkRequest {
    var httpMethod: HTTPMethod { .get }
    var dto: Encodable? { nil }
}
