//
//  ContentView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

struct ImageListView: View {
    
    @StateObject var viewModel: ImageListViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 20) {
                    switch viewModel.state {
                    case .loading:
                        ForEach(0..<3, id: \.self) { index in
                            GradientLoadingView(width: geometry.size.width, height: 250)
                        }
                    case .loaded(let itemsViewModels):
                        ForEach(0..<itemsViewModels.count, id: \.self) { index in
                            ImageItemView(width: geometry.size.width, height: 400, viewModel: itemsViewModels[index])
                        }
                    default:
                        EmptyView()
                    }
                }
            }
            .task {
                await viewModel.fetchImages()
            }
        }
    }
}
