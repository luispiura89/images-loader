//
//  DetailView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 7/3/25.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                switch viewModel.state {
                case .idle, .loading:
                    GradientLoadingView()
                        .frame(width: geometry.size.width)
                case .loaded(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                case .failed:
                    RetryImageLoadView(onTap: viewModel.retryImageLoad)
                }
            }
            .frame(height: geometry.size.height)
            .onAppear {
                viewModel.measureImageHeight(forScreenWidth: geometry.size.width)
            }
        }
        .frame(height: viewModel.cellHeight)
        .task {
            await viewModel.loadImage()
        }
    }
}
