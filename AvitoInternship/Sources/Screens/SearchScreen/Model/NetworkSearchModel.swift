import Foundation

// MARK: - NetworkSearchModelProtocol
protocol NetworkSearchModelProtocol {
        func fetchProducts(
            title: String?,
            categoryId: Int?,
            priceMin: Int?,
            priceMax: Int?,
            offset: Int,
            limit: Int
        ) async throws -> [ProductModel]
    
        func fetchCategories() async throws -> [Category]
}

// MARK: - NetworkSearchModel
final class NetworkSearchModel: NetworkSearchModelProtocol {
    private let networkingService = NetworkingService.shared

    func fetchProducts(
        title: String?,
        categoryId: Int?,
        priceMin: Int?,
        priceMax: Int?,
        offset: Int,
        limit: Int
    ) async throws -> [ProductModel] {
        return try await networkingService.getFilteredProductList(
            title: title,
            categoryId: categoryId,
            priceMin: priceMin,
            priceMax: priceMax,
            price: nil,
            offset: offset,
            limit: limit
        )
    }

    func fetchCategories() async throws -> [Category] {
        return try await networkingService.getCategoryList()
    }
}
