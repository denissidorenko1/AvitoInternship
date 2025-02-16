import Foundation
import Combine

final class BucketListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let model: BucketListModelProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published Properties
    @Published var itemList: [BucketListItem] = []
    @Published var selectedItem: ProductModel?
    @Published var isViewPresented: Bool = false {
        didSet {
            if !isViewPresented {
                selectedItem = nil
            }
        }
    }

    // MARK: - Computed Properties
    var purchaseListDescription: String {
        itemList.map { "\($0.quantity) x \($0.item.title)" }.joined(separator: "\n")
    }

    var totalPrice: Int {
        itemList.reduce(0) { $0 + ($1.quantity * $1.item.price) }
    }

    // MARK: - Initializer
    init(model: BucketListModelProtocol = BucketListModel()) {
        self.model = model
        loadPurchaseList()
    }

    // MARK: - Public Methods
    func showProductView(with item: ProductModel) {
        selectedItem = item
        isViewPresented = true
    }

    func incrementQuantity(for item: BucketListItem) {
        model.incrementQuantity(for: item)
        loadPurchaseList()
    }

    func decrementQuantity(for item: BucketListItem) {
        model.decrementQuantity(for: item)
        loadPurchaseList()
    }

    func deleteAllItems() {
        model.deleteAllItems()
        loadPurchaseList()
    }

    func loadPurchaseList() {
        itemList = model.loadPurchaseList()
    }
}
