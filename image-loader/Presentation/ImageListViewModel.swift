//
//  ImageListViewModel.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

final class ImageListViewModel: ObservableObject {
    
    // Possible states that the view can have
    enum State {
        case idle
        case loading
        case loaded([ImageItemViewModel])
        case error(Error)
    }
    
    @Published var state = State.idle
    
    private let imageLoader: ImageLoader
    
    /// Closure used to abstract the loading success in order to keep the view model agnostic
    /// of the loaded state
    var onImagesLoaded: (([ImageModel]) -> Void)?
    
    init(state: State = .idle, imageLoader: ImageLoader) {
        self.state = state
        self.imageLoader = imageLoader
    }
    
    @MainActor
    func fetchImages() async {
        guard case .idle = state else { return }
        state = .loading
        
        do {
            let images = try await imageLoader.getImages()
            onImagesLoaded?(images)
        } catch {}
    }
}
