import SwiftUI
import Kingfisher

// MARK: - CategoryView
struct CategoryView: View {
    var categoryName: String
    var categoryImageUrlString: String
    
    var body: some View {
        HStack {
            KFImage.url(URL(string: categoryImageUrlString))
                .resizable()
                .onFailureImage(UIImage(named: "imageNotFound"))
                .fade(duration: 0.25)
                .clipShape(.rect(cornerRadius: 5))
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
            Text(categoryName)
        }
    }
}

#Preview {
    CategoryView(categoryName: "Одежда", categoryImageUrlString: "")
}
