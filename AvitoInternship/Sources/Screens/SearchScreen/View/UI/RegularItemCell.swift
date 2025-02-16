import SwiftUI
import Kingfisher
import SkeletonUI

// MARK: - RegularItemCell
struct RegularItemCell: View {
    @Binding var item: ProductModel
    @State var quantity: Int = 0
    
    @EnvironmentObject var vm: SearchScreenViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            image
            VStack(alignment: .leading) {
                title
                Spacer()
                HStack {
                    if quantity > 0 {
                        minusIcon
                    }
                    price
                    plusIcon
                }
                .background(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.customBackground)
                })
            }
            .animation(.bouncy, value: quantity)
            .frame(height: 90)
        }
    }
    
    var image: some View {
        KFImage.url(URL(string: item.images.first ?? ""))
            .onFailureImage(UIImage(named: "imageNotFound"))
            .resizable()
            .clipShape(.rect(cornerRadius: 20))
            .aspectRatio(1, contentMode: .fill)
    }
    
    var title: some View {
        Text(item.title)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
    
    // FIXME: если будет время, поправить баг с неправильным отображением числа элементов между корзиной и ячейкой
    var minusIcon: some View {
        Image(systemName: "minus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundStyle(.customPink)
            .padding(.leading, 10)
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                quantity -= 1
                vm.decrementProduct(item)
            }
    }
    
    var price: some View {
        Text("\(item.price) ₽")
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .foregroundStyle(.customPink)
            .padding(.vertical, 8)
            .padding(.leading, 10)
            .font(.system(size: 16, weight: .semibold))
    }
    
    var plusIcon: some View {
        Image(systemName: "plus")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.customPink)
            .padding(.trailing, 10)
            .onTapGesture {
                quantity += 1
                vm.incrementProduct(item)
            }
    }
}

#Preview {
    RegularItemCell(
        item: .constant(
            ProductModel(
                id: 1,
                title: "Бипка",
                price: 169,
                description: "Что в чемодане? - Бипки",
                images: ["https://i.imgur.com/qNOjJje.jpeg"],
                category: Category(
                    id: 1,
                    name: "Анекдот категории Б",
                    image: "https://i.imgur.com/qNOjJje.jpeg"
                )
            )
        )
    )
}
