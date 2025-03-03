//
//  RemoteImage.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 28/2/25.
//

import Foundation

struct RemoteImage: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: URL
    
    var model: ImageModel {
        .init(id: id, author: author, width: width, height: height, url: download_url)
    }
}
