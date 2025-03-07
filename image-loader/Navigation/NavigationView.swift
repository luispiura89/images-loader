//
//  NavigationView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 6/3/25.
//

import SwiftUI

struct NavigationView<V: View>: View {
    
    @StateObject var pathHandler: NavigationViewPathHandler
    @ViewBuilder let rootView: () -> V

    
    var body: some View {
        NavigationStack(path: $pathHandler.path) {
            rootView()
                .navigationDestination(for: NavigationViewPath.self) { path in
                    if case .detail(let model) = path {
                        DetailView(
                            viewModel: .init(
                                model: model,
                                imageDataLoader: RemoteImageDataLoader(
                                    httpClient: URLSessionHTTPClient(session: .shared)
                                )
                            )
                        )
                    }
                }
        }
    }
}
