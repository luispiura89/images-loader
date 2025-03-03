//
//  URLSessionHTTPClient.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 28/2/25.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    struct URLSessionHTTPClientError: Swift.Error {}
    
    init(session: URLSession) {
        self.session = session

    }
    
    func get(url: URL) async throws -> Data {
        let (data, response) = try await session.data(for: .init(url: url))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLSessionHTTPClientError()
        }
        return data
    }
}
