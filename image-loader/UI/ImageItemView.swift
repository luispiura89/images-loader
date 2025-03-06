//
//  ImageItemView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

struct ImageItemView: View {

    @StateObject var viewModel: ImageItemViewModel
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let authorPad: CGFloat = 10
        static let horizontalPad: CGFloat = 10
        
        static let gradientOpacity: Double = 0.2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                switch viewModel.state {
                case .loading, .idle:
                    GradientLoadingView()
                        .task {
                            await viewModel.fetchImage(maxWidth: maxCellWidth(in: geometry))
                        }
                case let .loaded(image, author):
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
                        .onTapGesture(perform: viewModel.onTapView)
                    
                    Text(author)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(Constants.authorPad)
                default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.horizontal, Constants.horizontalPad)
            .onAppear {
                viewModel.measureCellHeight(withMacWidth: maxCellWidth(in: geometry))
            }
        }
        .frame(height: viewModel.cellHeight)
    }
    
    private func maxCellWidth(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.width - Constants.horizontalPad * 2
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(spacing: 20) {
                ImageItemView(
                    viewModel: .init(
                        model: .init(id: "1", author: "First author", width: 1000, height: 200, url: URL(string: "https://any-url.com/image.jpg")!),
                        imageDataLoader: RemoteImageDataLoader(httpClient: URLSessionHTTPClient(session: .shared)),
                        state: .loading
                    ) {}
                )
                
                ImageItemView(
                    viewModel: .init(
                        model: .init(id: "2", author: "Second author", width: 3000, height: 5000, url: URL(string: "https://any-url.com/image.jpg")!),
                        imageDataLoader: RemoteImageDataLoader(httpClient: URLSessionHTTPClient(session: .shared)),
                        state: .loaded(image: UIImage(systemName: "square.and.arrow.down")!, author: "This is the author")
                    ) {}
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
