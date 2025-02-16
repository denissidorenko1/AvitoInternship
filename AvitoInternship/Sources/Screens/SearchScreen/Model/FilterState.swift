import Foundation

// MARK: - FilterState
struct FilterState {
    var title: String? = nil
    var priceMin: Int? = nil
    var priceMax: Int? = nil
    var currentCategory: Category? = nil
    var currentCategoryId: Int? = nil
    var hasChanges: Bool = false
    
    mutating func reset() {
        title = nil
        priceMin = nil
        priceMax = nil
        currentCategory = nil
        currentCategoryId = nil
        hasChanges = true
    }
    
    mutating func update(from query: LastQuery) {
        title = query.text
        priceMin = query.priceMin
        priceMax = query.priceMax
        currentCategoryId = query.categoryId
        hasChanges = true
    }
}

