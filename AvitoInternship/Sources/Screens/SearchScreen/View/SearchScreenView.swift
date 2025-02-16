import SwiftUI
import UIKit
import Kingfisher
import SkeletonUI

// MARK: - SearchScreenView
struct SearchScreenView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())] // перенести в расширени
    @StateObject private var vm = SearchScreenViewModel()
    
    var body: some View {
        NavigationStack {
            switch vm.viewState {
            case .loading:
                loadView
            case .loaded:
                listView
                    .navigationTitle("Велосипед")
                    .navigationDestination(isPresented: $vm.isViewPresented) {
                        if let item = vm.selectedItem {
                            ItemCardView(
                                viewModel: ItemCardViewModel(
                                    item: item
                                )
                            )
                        }
                    }
            case .error:
                errorView
            case .empty:
                noResultsView
            case .options:
                searchOptions
            }
        }
        .searchable(
            text: Binding(
                get: { vm.title ?? ""},
                set: { vm.title = $0.isEmpty ? nil : $0 }
            ),
            isPresented: Binding(
                get: { vm.viewState == .options },
                set: { isPresented in vm.viewState = isPresented ? .options : .loaded }
            )
        )
        .onSubmit(of: .search) {
            vm.saveQuery()
            vm.fetchProducts()
            
        }
        .onAppear {
            vm.fetchProducts()
        }
    }
    
    
   
    

}

// MARK: - errorView
extension SearchScreenView {
    var errorView: some View {
        VStack {
            Spacer()
            unavailableImage
            errorTitle
            errorDescription
            Spacer()
            reloadView
        }
    }
    
    var unavailableImage: some View {
        Image("brokenBottle")
            .resizable()
            .scaledToFit()
            .frame(width: 200)
    }
    
    var errorTitle: some View {
        Text("Здесь что-то не так")
            .padding()
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.customTitle)
    }
    
    var errorDescription: some View {
        Text("Кажется, нет интернета. Проверьте сеть и перезагрузите приложение — это должно помочь")
            .padding(.horizontal, 40)
            .multilineTextAlignment(.center)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.customHighlight)
    }
    
    var reloadView: some View {
        Text("Перезагрузить")
            .frame(width: 340, height: 60)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.customTitle)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.customBackground)
            })
            .onTapGesture {
                vm.fetchProducts()
            }
            .padding(.bottom, 60)
    }
}

// MARK: - listView
extension SearchScreenView {
    var listView: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(vm.productList.indices, id: \.self) { index in
                    RegularItemCell(item: $vm.productList[index])
                        .environmentObject(vm)
                        .id(vm.productList[index].id)
                        .onAppear {
                            if index == vm.productList.count - 1 {
                                vm.loadNewPage()
                            }
                        }
                        .onTapGesture {
                            vm.didTapItem(vm.productList[index])
                        }
                    
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .overlay {
            bucketView
        }
        .onAppear() {
            vm.loadPurchaseList()
        }
        
    }
    
    var bucketView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                bucketButton
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        vm.showBucket()
                    }
                    .navigationDestination(
                        isPresented: $vm.isShowingBucket) {
                            BucketListView(vm: BucketListViewModel(itemList: vm.purchaseList))
                        }
            }
        }
    }
    
    var bucketButton: some View {
        Text("\(vm.purchaseList.map { $0.quantity * $0.item.price}.reduce(0, +)) ₽")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.vertical)
            .padding(.horizontal, 40)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 50)
                    .fill(.customPink)
            })
            .animation(.bouncy, value: vm.purchaseList)
    }
}

// MARK: - noResultsView
extension SearchScreenView {
    var noResultsView: some View {
        VStack {
            noResultsImage
            noResultsDescription
            Text("На главную")
                .frame(width: 340, height: 60)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.customTitle)
                .background(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(.customBackground)
                })
                .onTapGesture {
                    vm.clearFilter()
                }
        }
    }
    
    var noResultsImage: some View {
        Image("noResults")
            .resizable()
            .scaledToFit()
            .frame(width: 200)
    }
    
    var noResultsDescription: some View {
        Text("Ничего такого не нашлось")
            .padding()
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.customTitle)
    }
}

// MARK: - loadView
extension SearchScreenView {
    var loadView: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0..<10, id: \.self) { _ in
                    RegularItemSkeletonCell()
                }
            }
            .padding(.horizontal)
        }
        .scrollDisabled(true)
    }
}

// MARK: - searchOptions
extension SearchScreenView {
    var searchOptions: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    previousQueriesSection
                    priceFilterSection
                    categorySelectionSection
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .onAppear {
                vm.fetchRecentQueries()
                vm.fetchCategories()
            }
            
            actionButtons
        }
    }
}

// MARK: - previousQueriesSection
extension SearchScreenView {
    var previousQueriesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ранее заказывали")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.customTitle)
                .padding(.bottom)
            
            ForEach(vm.latestQueries, id: \.date) { item in
                RecentQueryView(
                    searchQuery: item.text,
                    minPrice: item.priceMin,
                    maxPrice: item.priceMax,
                    categoryName: item.categoryName
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.fetchFromRecentQuery(with: item)
                }
                Divider()
            }
        }
    }
}

// MARK: - priceFilterSection
extension SearchScreenView {
    var priceFilterSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Цена")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.customText)
            
            HStack {
                priceTextField(title: "От", value: $vm.priceMin)
                priceTextField(title: "До", value: $vm.priceMax)
            }
            .padding(.vertical)
            
            Divider()
        }
    }
    
    func priceTextField(title: String, value: Binding<String?>) -> some View {
        TextField(title, text: Binding(
            get: { value.wrappedValue ?? "" },
            set: { value.wrappedValue = $0.isEmpty ? nil : $0 }
        ))
        .padding(10)
        .foregroundStyle(.customText)
        .keyboardType(.decimalPad)
        .background(RoundedRectangle(cornerRadius: 5).fill(.customBackground))
    }
}

// MARK: - categorySelectionSection
private extension SearchScreenView {
    var categorySelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Снять выбор категории")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.customText)
                Spacer()
                
                deleteCategoryButton
            }
            
            Divider()
            
            ForEach(vm.categories, id: \.id) { category in
                CategoryView(categoryName: category.name, categoryImageUrlString: category.image)
                    .foregroundStyle(vm.currentCategory == category ? Color.blue : Color.gray)
                    .onTapGesture {
                        vm.didSelectCategory(category)
                    }
                    .animation(.bouncy, value: vm.currentCategory)
            }
        }
    }
    
    var deleteCategoryButton: some View {
        Image(systemName: "delete.left")
            .frame(width: 20, height: 20)
            .padding(10)
            .foregroundStyle(.customHighlight)
            .background(Circle().fill(.customBackground))
            .onTapGesture {
                vm.clearCurrentCategory()
            }
    }
}

// MARK: - actionButtons
private extension SearchScreenView {
    var actionButtons: some View {
        HStack {
            actionButton(title: "Сбросить поиск", color: .customHighlight) {
                vm.clearFilter()
            }
            Spacer()
            actionButton(title: "Поиск", color: .customPink) {
                vm.saveQuery()
                vm.fetchProducts()
            }
        }
        .padding(.horizontal)
    }
    
    func actionButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Text(title)
            .frame(width: 170, height: 50)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 35).fill(color))
            .onTapGesture(perform: action)
    }
}

#Preview {
    SearchScreenView()
}
