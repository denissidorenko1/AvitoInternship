import SwiftUI
import Kingfisher

// MARK: - BucketListItemCell
struct BucketListItemCell: View {
    // MARK: - Properties
    @Binding var item: BucketListItem
    @EnvironmentObject var vm: BucketListViewModel
    
    var body: some View {
        HStack {
            image
            VStack(alignment: .leading) {
                title
                Spacer()
                QuantityTogglerView(item: item)
                    .environmentObject(vm)
            }
            
            Spacer()
            VStack {
                Spacer()
                totalPrice
            }
        }
        .frame(height: 100)
    }
    
    var image: some View {
        KFImage.url(URL(string: item.item.images.first ?? ""))
            .onFailureImage(UIImage(named: "imageNotFound"))
            .resizable()
            .clipShape(.rect(cornerRadius: 20))
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 100)
    }
    
    var title: some View {
        Text(item.item.title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.customText)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
    }
    
    var totalPrice: some View {
        Text("\(item.item.price * item.quantity) ₽")
            .font(.system(size: 20, weight: .bold))
            .animation(.easeInOut, value: item.quantity)
    }
    
}

#Preview {
    @Previewable @StateObject var vm: BucketListViewModel = BucketListViewModel(
        itemList: [BucketListItem(
            item: ProductModel(
                id: 1,
                title: "Бальзам для губ Самокат, Mango Care",
                price: 199,
                description: "",
                images: ["https://i.imgur.com/jVfoZnP.jpg"],
                category: Category(
                    id: 1,
                    name: "Другое",
                    image: ""
                )
            ),
            quantity: 1
        ) ]
    )
    
    BucketListItemCell(item: $vm.itemList[0])
        .environmentObject(vm)
}
