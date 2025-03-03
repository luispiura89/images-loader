//
//  RemoteImageLoader.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 3/3/25.
//

import Foundation

final class RemoteImageLoader: ImageLoader {
    
    private let httpClient: HTTPClient
    private let url: URL
    
    init(
        httpClient: HTTPClient,
        url: URL
    ) {
        self.httpClient = httpClient
        self.url = url
    }
    
    func getImages() async throws -> [ImageModel] {
        let data = try await httpClient.get(url: url)
        let images = try? JSONDecoder().decode([RemoteImage].self, from: data)
        return images?.compactMap { $0.model } ?? []
    }
}
