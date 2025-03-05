//
//  image_loaderApp.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

@main
struct image_loaderApp: App {
    
    var baseURL: URL {
        guard let url = URL(string: "https://picsum.photos/v2/list") else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var body: some Scene {
        WindowGroup {
            makeImageListView()
        }
    }
    
    private func makeImageListView() -> some View {
        let httpClient = URLSessionHTTPClient(session: .shared)
        let imageLoader = RemoteImageLoader(httpClient: httpClient, url: baseURL)
        let viewModel = ImageListViewModel(imageLoader: imageLoader)
        viewModel.onImagesLoaded = { images in
            viewModel.state = .loaded(
                images.map {
                    .init(
                        model: $0,
                        imageDataLoader: RemoteImageDataLoader(httpClient: httpClient)
                    )
                }
            )
        }
        
        return ImageListView(viewModel: viewModel)
    }
}
