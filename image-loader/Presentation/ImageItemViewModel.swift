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
    @Published var cellHeight: CGFloat = 200
    
    private var didMeasureSize = false
    
    private let model: ImageModel
    private let imageDataLoader: ImageDataLoader
    private let onTap: () -> Void
    
    init(
        model: ImageModel,
        imageDataLoader: ImageDataLoader,
        state: State = .idle,
        onTap: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.imageDataLoader = imageDataLoader
        self.onTap = onTap
    }

    @MainActor
    func fetchImage(maxWidth: CGFloat) async {
        if case .loaded = state {
            return
        }
        state = .loading
        do {
            let imageData = try await imageDataLoader.getImageData(
                fromURL: model.url.replaceWidthAndHeightPathComponents(with: maxWidth, height: cellHeight)
            )
            if let uiImage = UIImage(data: imageData) {
                state = .loaded(image: uiImage, author: model.author)
            }
        } catch {}
    }
    
    func measureCellHeight(withMacWidth maxWidth: CGFloat) {
        guard !didMeasureSize else { return }
        cellHeight = model.height.cgFloat / model.width.cgFloat * maxWidth
        didMeasureSize = true
    }
    
    func onTapView() {
        onTap()
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

private extension Int {
    
    var cgFloat: CGFloat {
        .init(self)
    }
    
}
