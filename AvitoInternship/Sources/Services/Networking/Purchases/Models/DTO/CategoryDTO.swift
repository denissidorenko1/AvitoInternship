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

enum SizeType {
    case large
    case regular
}

extension SizeType: Codable {
    
}

struct Category {
    let id: Int
    let name: String
    let image: String
    let sizeType: SizeType
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
            image: image,
            sizeType: id % 2 == 0 ? .large : .regular
        )
    }
}
