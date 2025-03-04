//
//  ImageItemViewModel.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI
import UIKit

final class ImageItemViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded(image: UIImage, author: String)
        case error(Error)
    }
    
    @Published var state: State = .idle
    @Published var cellHeight: CGFloat = 0
    
    private let imageURL: URL
    private let authorName: String
    private let imageDataLoader: ImageDataLoader
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    
    init(
        imageURL: URL,
        authorName: String,
        imageDataLoader: ImageDataLoader,
        imageWidth: CGFloat = 0,
        imageHeight: CGFloat = 0,
        state: State = .idle
    ) {
        self.imageURL = imageURL
        self.authorName = authorName
        self.state = state
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.imageDataLoader = imageDataLoader
    }

    @MainActor
    func fetchImage(maxWidth: CGFloat) async {
//        guard case .idle = state else { return }
        state = .loading
//        Task { @MainActor in
            do {
                let imageData = try await imageDataLoader.getImageData(
                    fromURL: imageURL.replaceWidthAndHeightPathComponents(with: maxWidth, height: cellHeight)
                )
                if let uiImage = UIImage(data: imageData) {
                    state = .loaded(image: uiImage, author: authorName)
                }
            } catch {}
//        }
    }
    
    func measureCellHeight(withMacWidth maxWidth: CGFloat) {
        guard cellHeight == 0 else { return }
        cellHeight = (imageHeight / imageWidth) * maxWidth
    }
}

private extension URL {
    
    func replaceWidthAndHeightPathComponents(with width: CGFloat, height: CGFloat) -> URL {
        deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "\(Int(ceil(width)))")
            .appending(path: "\(Int(ceil(height)))")
    }
    
}
