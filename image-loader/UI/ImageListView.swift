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
        ScrollView {
            switch viewModel.state {
            case .loading:
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        GradientLoadingView()
                            .frame(height: 250)
                    }
                }
                .padding(.horizontal, 10)
            case .loaded(let itemsViewModels):
                LazyVStack(spacing: 20) {
                    ForEach(0..<itemsViewModels.count, id: \.self) { index in
                        ImageItemView(viewModel: itemsViewModels[index])
                    }
                }
            default:
                EmptyView()
            }
        }
        .scrollIndicators(.hidden)
        .task {
            await viewModel.fetchImages()
        }
    }
}
