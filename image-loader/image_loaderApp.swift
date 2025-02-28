//
//  image_loaderApp.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

@main
struct image_loaderApp: App {
    var body: some Scene {
        WindowGroup {
            makeImageListView()
        }
    }
    
    private func makeImageListView() -> some View {
        let viewModel = ImageListViewModel()
        viewModel.onImagesLoaded = {
            viewModel.state = .loaded([])
        }
        
        return ImageListView(viewModel: viewModel)
    }
}
