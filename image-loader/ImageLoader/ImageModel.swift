//
//  Image.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 3/3/25.
//

import Foundation

struct ImageModel: Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL
}
