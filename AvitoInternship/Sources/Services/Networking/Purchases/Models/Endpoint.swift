import Foundation

// MARK: Endpoint
enum Endpoint {
    // MARK: - Cases
    case products(offset: Int, limit: Int)
    case categories
    case filteredProducts(title: String?, categoryId: Int?, priceMin: Int?, priceMax: Int?, price: Int?, offset: Int, limit: Int)
    
    // MARK: - Public Properties
    static let baseURL: URL = URL(string: "https://api.escuelajs.co/api/v1")!
    
    // MARK: - Computed Properties
    var path: String {
        switch self {
            case .products: "products"
            case .categories: "categories"
            case .filteredProducts: "products"
        }
    }
    
    var url: URL? {
        var components = URLComponents(url: Endpoint.baseURL.appending(path: self.path), resolvingAgainstBaseURL: false)
        switch self {
        case let .products(offset, limit):
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            components?.queryItems = queryItems.isEmpty ? nil : queryItems
            return components?.url
        case .categories:
            return components?.url
        case let .filteredProducts(title, categoryId, priceMin, priceMax, _, offset, limit):
            var queryItems: [URLQueryItem] = []
            if let title {
                queryItems.append(URLQueryItem(name: "title", value: title))
            }
            if let categoryId {
                queryItems.append(URLQueryItem(name: "categoryId", value: String(categoryId)))
            }
            if let priceMin {
                queryItems.append(URLQueryItem(name: "price_min", value: String(priceMin)))
            }
            if let priceMax {
                queryItems.append(URLQueryItem(name: "price_max", value: String(priceMax)))
            }
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            components?.queryItems = queryItems.isEmpty ? nil : queryItems
            return components?.url
        }
    }
}
