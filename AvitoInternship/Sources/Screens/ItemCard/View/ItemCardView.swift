import SwiftUI
import Kingfisher

// MARK: - ItemCardView
struct ItemCardView: View {
    @StateObject var viewModel: ItemCardViewModel
    @State private var currentIndex = 0
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(.customBackground)
            VStack(alignment: .leading) {
                imageContainer
                descriptionContainer
            }
            VStack{
                Spacer()
                purchaseContainer
            }
            .ignoresSafeArea(.all)
        }
        .onAppear {
            viewModel.didAppear()
        }
    }
}

// MARK: - imageContainer
extension ItemCardView {
    var imageContainer: some View {
        VStack(spacing:0) {
            TabView(selection: $currentIndex) {
                ForEach(0..<viewModel.item.images.count, id: \.self) { imageIndex in
                    KFImage.url(URL(string: viewModel.item.images[imageIndex]))
                        .onFailureImage(UIImage(named: "imageNotFound"))
                        .resizable()
                        .clipShape(.rect(cornerRadius: 20))
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        }
        .padding(.horizontal)
        .onReceive(timer){ _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % viewModel.item.images.count
            }
        }
    }
}

// MARK: - descriptionContainer
extension ItemCardView {
    var descriptionContainer: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    title
                    Spacer()
                    ShareLink(item: viewModel.shareString) {
                        shareButton
                            .padding(.top)
                    }
                }
                Divider()
                categoryName
                Divider()
                description
            }
        }
        .multilineTextAlignment(.leading)
        .scrollIndicators(.never)
        .padding(.horizontal)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 25)
        })
    }
    
    var title: some View {
        Text(viewModel.item.title)
            .foregroundStyle(.customTitle)
            .font(.system(size: 22, weight: .bold) )
            .lineLimit(3)
            .padding(.top)
    }
    
    var categoryName: some View {
        Text(viewModel.item.category.name)
            .padding(.vertical, 2)
            .foregroundStyle(.customText)
            .font(.system(size: 16, weight: .medium) )
    }
    
    var description: some View {
        Text(viewModel.item.description)
            .lineLimit(20)
            .foregroundStyle(.customText)
            .font(.system(size: 16, weight: .medium) )
            .padding(.bottom, 100)
    }
    
    
    var shareButton: some View {
        Image(systemName: "square.and.arrow.up")
            .padding(10)
            .foregroundStyle(.customHighlight)
            .background(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.customBackground)
            })
    }
}

// MARK: - PurchaseContainer
extension ItemCardView {
    var purchaseContainer: some View {
        VStack {
            if viewModel.itemCount == 0 {
                EmptyView()
            } else {
                Text("В корзине \(viewModel.itemCount) шт")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
        HStack() {
            Spacer()
            
            if viewModel.itemCount > 0 {
                minusImage
            }
            price
            plusImage
            Spacer()
        }
    }
        .frame(height: 90)
        .clipShape(.rect)
        .background(alignment: .center, content: {
            Rectangle()
                .fill(.customPink)
        })
        .foregroundStyle(.white)
        .font(.title2)
        .animation(.bouncy, value: viewModel.itemCount)
    }
    
    var price: some View {
        Text("\(viewModel.item.price) ₽")
            .foregroundStyle(.customBackground)
            .font(.system(size: 22, weight: .bold))
    }
    
    var plusImage: some View {
        Image(systemName: "plus")
            .resizable()
            .frame(width: 25, height: 25)
            .padding(5)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.didTapPlus()
            }
    }
    
    var minusImage: some View {
        Image(systemName: "minus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .padding(5)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.didTapMinus()
            }
    }
}


#Preview {
    ItemCardView(
        viewModel: ItemCardViewModel(
            item: ProductModel(
                id: 1,
                title: "Зубная паста Самокат, отбеливающая, тропический кокос",
                price: 295,
                description: "Золотые мишки Haribo - мармелад № 1! Основатель категории жевательного мармелада в России! Его знают и любят во всем мире! На протяжении 90 лет Золотые мишки - это эталон фруктового жевательного мармелада и лучший друг внимательной и заботливой мамы, которая любит угощать своего ребенка легкими и фруктовыми сладостями. Жевательный мармелад со вкусом клубники, лимона, малины, апельсина, ананаса и яблока никого не оставит равнодушным!",
                images: [
                    "https://i.imgur.com/7OqTPO6.jpg",
                    "https://i.imgur.com/Tnl15XK.jpg",
                    "https://i.imgur.com/jVfoZnP.jpg"
                ],
                category: Category.init(
                    id: 1,
                    name: "Тестовая категория",
                    image: ""
                )
            )
        )
    )
}
