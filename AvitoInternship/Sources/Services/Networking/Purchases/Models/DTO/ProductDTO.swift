import Foundation

// MARK: - GetProductRequest
struct ProductDTO: Codable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    let creationAt: String
    let updatedAt: String
    let category: CategoryDTO
}

struct ProductModel {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    let category: Category
}

extension ProductModel: Identifiable {
    
}

extension ProductDTO {
    var toProductModel: ProductModel {
        return ProductModel(
            id: id,
            title: title,
            price: price,
            description: description,
            images: images,
            category: category.toCategory
        )
    }
}

extension ProductModel: Codable {
    
}
