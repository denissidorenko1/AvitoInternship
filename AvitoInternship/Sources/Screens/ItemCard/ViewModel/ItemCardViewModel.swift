import Foundation
import SwiftUI

// MARK: - ItemCardViewModelProtocol
protocol ItemCardViewModelProtocol {
    var item: ProductModel { get }
    var itemCount: Int  { get }
    
    var shareString: String { get }
    
    func didTapMinus()
    func didTapPlus()
    func didAppear()
}

// MARK: - ItemCardViewModel
final class ItemCardViewModel: ItemCardViewModelProtocol, ObservableObject {
    // MARK: - Dependencies
    private let model: ItemCardModel
    // MARK: - Initializer
    init(item: ProductModel, model: ItemCardModel = ItemCardModel()) {
        self.item = item
        self.model = model
    }
    
    // MARK: - Published properties
    @Published var item: ProductModel
    @Published var itemCount: Int = 0
    
    // MARK: - Computed Properties
    var shareString: String {
        [item.title, item.category.name, item.description].joined(separator: "\n")
    }
    
    // MARK: - Public Methods
    func didTapMinus() {
        model.decrementProduct(item)
        itemCount = model.getCurrentItemCount(with: item)
    }
    
    func didTapPlus() {
        model.incrementProduct(item)
        itemCount = model.getCurrentItemCount(with: item)
    }
    
    func didAppear() {
        itemCount = model.getCurrentItemCount(with: item)
    }
}
