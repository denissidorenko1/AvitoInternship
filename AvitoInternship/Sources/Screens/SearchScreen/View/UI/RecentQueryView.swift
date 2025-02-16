import SwiftUI

// MARK: - RecentQueryView
struct RecentQueryView: View {
    
    @State var searchQuery: String?
    @State var minPrice: Int?
    @State var maxPrice: Int?
    @State var categoryName: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(searchQuery ?? "Без текстового запроса")
                .foregroundStyle(.customText)
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 5)
            Group {
                switch (minPrice, maxPrice) {
                case (nil, nil):
                    EmptyView()
                case (.some(let min), .some(let max)):
                    Text("От \(min) до \(max) ₽")
                case (.some(let min), nil):
                    Text("От \(min) ₽")
                case (nil, .some(let max)):
                    Text("До \(max) ₽")
                }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.customHighlight)
            .padding(.bottom, 5)
            if let categoryName {
                Text(categoryName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.customHighlight)
            }
        }
    }
}
