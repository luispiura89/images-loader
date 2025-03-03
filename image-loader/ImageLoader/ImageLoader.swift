//
//  ImageLoader.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 28/2/25.
//

protocol ImageLoader {
    func getImages() async throws -> [ImageModel]
}
