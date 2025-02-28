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
    
    private let imageURL: URL
    private let authorName: String
    
    init(imageURL: URL, authorName: String, state: State = .loading) {
        self.imageURL = imageURL
        self.authorName = authorName
        self.state = state
    }
    
}
