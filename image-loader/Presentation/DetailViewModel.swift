//
//  DetailViewModel.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 7/3/25.
//

import SwiftUI

final class DetailViewModel: ObservableObject {

    private let model: ImageModel
    private let imageDataLoader: ImageDataLoader
    
    enum State {
        case idle
        case loading
        case loaded(UIImage)
        case failed(Error)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var cellHeight: CGFloat = 200
    
    init(model: ImageModel, imageDataLoader: ImageDataLoader) {
        self.model = model
        self.imageDataLoader = imageDataLoader
    }
    
    @MainActor
    func loadImage() async {
        state = .loading
        do {
            if Task.isCancelled {
                return
            }
            let imageData = try await imageDataLoader.getImageData(fromURL: model.url)
            guard let image = UIImage(data: imageData) else {
                return
            }
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
    
    func retryImageLoad() {
        Task { @MainActor in
            await loadImage()
        }
    }
    
    func measureImageHeight(forScreenWidth screenWidth: CGFloat) {
        cellHeight = (model.height.cgFloat / model.width.cgFloat) * screenWidth
    }
}
