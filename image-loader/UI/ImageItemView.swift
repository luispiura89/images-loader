//
//  ImageItemView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

struct ImageItemView: View {
    
    let width: CGFloat
    @StateObject var viewModel: ImageItemViewModel
    
//    init(width: CGFloat, viewModel: ImageItemViewModel) {
//        self.width = width
//        self.viewModel = viewModel
//        
//        self.viewModel.measureCellHeight(withMacWidth: width)
//    }
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let authorPad: CGFloat = 10
        static let horizontalPad: CGFloat = 20
        
        static let gradientOpacity: Double = 0.2
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                GradientLoadingView(width: width, height: viewModel.cellHeight)
            case let .loaded(image, author):
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
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
        .frame(width: width - Constants.horizontalPad, height: viewModel.cellHeight)
        .onAppear {
            viewModel.measureCellHeight(withMacWidth: width - Constants.horizontalPad)
        }
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(spacing: 20) {
                ImageItemView(
                    width: geometry.size.width,
                    viewModel: .init(
                        imageURL: URL(string: "https://any-url.com/image.jpg")!,
                        authorName: "This is the first author",
                        state: .loading
                    )
                )
                
                ImageItemView(
                    width: geometry.size.width,
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
