//
//  RemoteImageDataLoader.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 4/3/25.
//

import Foundation

final class RemoteImageDataLoader: ImageDataLoader {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getImageData(fromURL: URL) async throws -> Data {
        try await httpClient.get(url: fromURL)
    }
    
}
