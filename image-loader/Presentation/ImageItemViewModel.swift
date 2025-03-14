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
        case failure(Error)
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
            if Task.isCancelled {
                return
            }
            let imageData = try await imageDataLoader.getImageData(
                fromURL: model.url.replaceWidthAndHeightPathComponents(with: maxWidth, height: cellHeight)
            )
            if let uiImage = UIImage(data: imageData) {
                state = .loaded(image: uiImage, author: model.author)
            }
        } catch {
            if Task.isCancelled {
                return
            }
            state = .failure(error)
        }
    }
    
    func retryImageLoad(maxWidth: CGFloat) {
        Task { @MainActor in
            await fetchImage(maxWidth: maxWidth)
        }
    }
    
    func measureCellHeight(withMacWidth maxWidth: CGFloat) {
        guard !didMeasureSize else { return }
        cellHeight = model.height.cgFloat / model.width.cgFloat * maxWidth
        didMeasureSize = true
    }
    
    func onTapView() {
        if case .loaded = state {
            onTap()
        }
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

extension Int {
    
    var cgFloat: CGFloat {
        .init(self)
    }
    
}
