import Foundation
import SwiftUI
// MARK: - ItemCardViewModel
final class ItemCardViewModel: Observable {
    // MARK: - Initializer
    init(item: ProductModel) {
        self.item = item
    }
    
    // MARK: - Published properties
    @Published var item: ProductModel
    
    // MARK: - Computed Properties
    
    var shareString: String {
        [item.title, item.category.name, item.description].joined(separator: "\n")
    }
}
