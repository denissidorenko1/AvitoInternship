import SwiftUI

// MARK: - QuantityTogglerView
struct QuantityTogglerView: View {
    var item: BucketListItem
    @EnvironmentObject var vm: BucketListViewModel
    
    var body: some View {
        HStack {
            minusImage
            Text("\(item.quantity)")
            plusImage
            
        }
        .frame(height: 25)
        .padding(.vertical, 5)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 25)
                .fill(.customBackground)
        })
        .animation(.easeInOut, value: vm.itemList.count)
    }
    
    var minusImage: some View {
        Image(systemName: "minus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundStyle(.customText)
            .padding(10)
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.decrementQuantity(for: item)
            }
    }
    
    var plusImage: some View {
        Image(systemName: "plus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundStyle(.customText)
            .padding(10)
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.incrementQuantity(for: item)
            }
    }
}
