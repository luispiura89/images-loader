//
//  ImageItemView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

struct ImageItemView: View {
    
    let width: CGFloat
    let height: CGFloat
    
    @StateObject var viewModel: ImageItemViewModel
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let authorPad: CGFloat = 10
        static let horizontalPad: CGFloat = 20
        
        static let gradientOpacity: Double = 0.2
    }
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            GradientLoadingView(width: width, height: height)
        case let .loaded(image, author):
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width - Constants.horizontalPad, height: height)
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [.clear, .black.opacity(Constants.gradientOpacity)]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(author)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(Constants.authorPad)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        default:
            EmptyView()
        }
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(spacing: 20) {
                ImageItemView(
                    width: geometry.size.width,
                    height: 230,
                    viewModel: .init(
                        imageURL: URL(string: "https://any-url.com/image.jpg")!,
                        authorName: "This is the first author",
                        state: .loading
                    )
                )
                
                ImageItemView(
                    width: geometry.size.width,
                    height: 230,
                    viewModel: .init(
                        imageURL: URL(string: "https://any-url.com/image.jpg")!,
                        authorName: "This is the first author",
                        state: .loaded(image: UIImage(systemName: "square.and.arrow.down")!, author: "This is the author")
                    )
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
