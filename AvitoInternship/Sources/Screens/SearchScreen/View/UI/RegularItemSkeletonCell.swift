import SwiftUI

// MARK: RegularItemSkeletonCell
struct RegularItemSkeletonCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            imagePlaceholder

            VStack(alignment: .leading) {
                titlePlaceholder
                HStack {
                    minusIconPlaceholder
                    pricePlaceholder
                    plusIconPlaceholder
                    Spacer()
                }
                .frame(width: 130)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.2))
                )
            }
            .frame(height: 80)
        }
        .frame(height: 230)
    }
    
    var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray.opacity(0.3))
            .skeleton(with: true, shape: .rounded(.radius(20)))
    }
    
    var titlePlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3))
            .skeleton(with: true, shape: .rounded(.radius(4)))
    }
    
    var minusIconPlaceholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 20, height: 20)
            .skeleton(with: true, shape: .circle)
    }
    
    var pricePlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 20, height: 20)
            .skeleton(with: true, shape: .rounded(.radius(4)))
    }
    
    var plusIconPlaceholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 20, height: 20)
            .skeleton(with: true, shape: .circle)
    }
}

#Preview {
    RegularItemSkeletonCell()
//        .frame(height: 100)
}
