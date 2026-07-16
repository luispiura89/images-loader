//
//  DetailViewModel.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 7/3/25.
//

import SwiftUI

final class DetailViewModel: ObservableObject {

    private let model: ImageModel
    
    @Published private(set) var cellHeight: CGFloat = 200
    @Published private(set) var url: URL?
    
    init(model: ImageModel) {
        self.model = model
        self.url = model.url
    }
    
    func measureImageHeight(forScreenWidth screenWidth: CGFloat) {
        cellHeight = (model.height.cgFloat / model.width.cgFloat) * screenWidth
    }
}
