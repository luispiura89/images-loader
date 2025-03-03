//
//  HTTPClient.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 28/2/25.
//


import Foundation

protocol HTTPClient {
    
    /// Function to fetch data asynchronously with network requests
    /// - Parameter url: URL
    /// - Returns: The fetched data
    func get(url: URL) async throws -> Data
}
