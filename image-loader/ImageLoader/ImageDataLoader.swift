//
//  ImageDataLoader.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 4/3/25.
//

import Foundation

protocol ImageDataLoader {
    func getImageData(fromURL: URL) async throws -> Data
}
