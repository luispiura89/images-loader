//
//  ImageItemViewModel.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import Foundation
import SwiftUI

final class ImageItemViewModel: ObservableObject {
    
    private let model: ImageModel
    private let onTap: () -> Void
    private var didMeasureSize = false
    
    @Published var cellHeight: CGFloat = 200

    let author: String
    
    init(
        model: ImageModel,
        onTap: @escaping () -> Void
    ) {
        self.model = model
        self.onTap = onTap
        author = model.author
    }
    
    func url(maxWidth: CGFloat) -> URL {
        model.url.replaceWidthAndHeightPathComponents(with: maxWidth, height: cellHeight)
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

extension Int {
    
    var cgFloat: CGFloat {
        .init(self)
    }
    
}
