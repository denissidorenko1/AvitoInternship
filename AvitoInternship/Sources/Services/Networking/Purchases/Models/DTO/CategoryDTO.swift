import Foundation

// MARK: - GetCategoryRequest
struct CategoryDTO: Codable {
    let id: Int
    let name: String
    let image: String
    let creationAt: String
    let updatedAt: String
}

// FIXME: - перенести это в нормальное место

struct Category {
    let id: Int
    let name: String
    let image: String
}

extension Category: Equatable {
    
}

extension Category: Codable {
    
}

extension CategoryDTO {
    var toCategory: Category {
        return Category(
            id: id,
            name: name,
            image: image
        )
    }
}
