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
                        .frame(width: geometry.size.width, height: viewModel.cellHeight)
                case .loaded(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: viewModel.cellHeight)
                case .failed:
                    Text("Error loading image")
                }
            }
            .frame(height: geometry.size.height)
            .onAppear {
                viewModel.measureImageHeight(forScreenWidth: geometry.size.width)
            }
        }
        .task {
            await viewModel.loadImage()
        }
    }
}
