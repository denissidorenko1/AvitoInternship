import SwiftUI

// MARK: - BucketListView
struct BucketListView: View {
    @StateObject var vm: BucketListViewModel
    
    var body: some View {
        NavigationStack {
            shareSection
            clearBucketSection
            Divider()
            VStack {
                List($vm.itemList, id: \.item.id) { $item in
                    BucketListItemCell(item: $item)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in return 0}
                        .onTapGesture {
                            vm.showProductView(with: item.item)
                        }
                }
                .animation(.easeInOut, value: vm.itemList.count)
                .listStyle(.plain)
                orderBlock
                    .background(Color.customBackground)
            }
            .navigationTitle("Корзина")
            .navigationDestination(
                isPresented: $vm.isViewPresented) {
                    if let item = vm.selectedItem {
                        ItemCardView(viewModel: ItemCardViewModel(item: item))
                    }
                }
            
        }
        .environmentObject(vm)
        .onAppear {
            vm.loadPurchaseList()
        }
    }
    
    
    var orderBlock: some View {
        HStack {
            Spacer()
            
            VStack {
                Text("Итого")
                    .padding(.top, 15)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.customHighlight)
                Text("\(vm.totalPrice) ₽")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.customText)
                    .animation(.bouncy)
                orderButton
            }
            Spacer()
        }
    }
    
    var orderButton: some View {
        Text("Оплатить")
            .frame(width: 330, height: 70)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.customPink)
            })
    }
    
    var shareButton: some View {
        Image(systemName: "square.and.arrow.up")
            .frame(width: 22, height: 20)
            .padding(10)
            .foregroundStyle(.customHighlight)
            .background(alignment: .center, content: {
                Circle()
                    .fill(.customBackground)
            })
    }
    
    var deleteButton: some View {
        Image(systemName: "delete.left")
            .frame(width: 22, height: 20)
            .padding(10)
            .foregroundStyle(.customHighlight)
            .background(alignment: .center, content: {
                Circle()
                
                    .fill(.customBackground)
            })
            .onTapGesture {
                vm.deleteAllItems()
            }
    }
    
}

extension BucketListView {
    var shareSection: some View {
        HStack {
            Text("Поделиться")
                .padding(.leading)
                .padding(.vertical, 2)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.customText)
            Spacer()
            ShareLink(item: vm.purchaseListDescription) {
                shareButton
                    .padding(.trailing)
            }
        }
    }
}

extension BucketListView {
    var clearBucketSection: some View {
        HStack {
            Text("Очистить список")
                .padding(.leading)
                .padding(.vertical, 2)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.customText)
            Spacer()
            deleteButton
                .padding(.trailing)
            
        }
    }
}


#Preview {
    BucketListView(
        vm:  BucketListViewModel(itemList: [])
    )
}
