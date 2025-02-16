import Foundation

// MARK: - ToDoNetworkingService
final class NetworkingService {

    // MARK: - Dependencies
    static let shared = NetworkingService()

    // MARK: - Private properties
    private let networkingService: NetworkingServiceProtocol

    // MARK: - Initializer
    init(networkingService: NetworkingServiceProtocol = DefaultNetworkingService() ) {
        self.networkingService = networkingService
    }

    // MARK: - Public Methods
    func getCategoryList() async throws -> [Category] {
        try await networkingService.send(request: GetCategoryRequest(), type: [CategoryDTO].self).map { $0.toCategory }
    }
    
    func getProductList(offset: Int, limit: Int) async throws -> [ProductModel] {
        return try await networkingService.send(request: GetProductRequest(offset: offset, limit: limit), type: [ProductDTO].self).map { $0.toProductModel }
    }
    
    func getFilteredProductList(
        title: String? = nil,
        categoryId: Int? = nil,
        priceMin: Int? = nil,
        priceMax: Int? = nil,
        price: Int? = nil,
        offset: Int,
        limit: Int
    ) async throws -> [ProductModel] {
        return try await networkingService.send(
            request: GetFilteredProductRequest(
                title: title,
                categoryId: categoryId,
                priceMin: priceMin,
                priceMax: priceMax,
                price: price,
                offset: offset,
                limit: limit
            ),
            type: [ProductDTO].self
        ).map { $0.toProductModel }
    }
}
