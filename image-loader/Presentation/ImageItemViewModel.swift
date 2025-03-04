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
        case loading
        case loaded(image: UIImage, author: String)
        case error(Error)
    }
    
    @Published var state: State = .loading
    @Published var cellHeight: CGFloat = 0
    
    private let imageURL: URL
    private let authorName: String
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    
    init(
        imageURL: URL,
        authorName: String,
        imageWidth: CGFloat = 0,
        imageHeight: CGFloat = 0,
        state: State = .loading
    ) {
        self.imageURL = imageURL
        self.authorName = authorName
        self.state = state
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    func measureCellHeight(withMacWidth maxWidth: CGFloat) {
        cellHeight = (imageHeight / imageWidth) * (maxWidth - 20)
    }
}
