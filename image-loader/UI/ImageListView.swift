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
            case .loading, .idle:
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        GradientLoadingView()
                            .frame(height: 250)
                    }
                }
                .padding(.horizontal, 10)
                .task {
                    await viewModel.fetchImages()
                }
            case .loaded(let itemsViewModels):
                LazyVStack(spacing: 20) {
                    ForEach(0..<itemsViewModels.count, id: \.self) { index in
                        ImageItemView(viewModel: itemsViewModels[index])
                    }
                }
            case .failure:
                RetryLoadItemsView(onTap: viewModel.retryLoading)
            }
        }
        .scrollIndicators(.hidden)
    }
}
