//
//  image_loaderTests.swift
//  image-loaderTests
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import XCTest
@testable import image_loader

final class image_loaderTests: XCTestCase {

    func test_init_setsInitialState() {
        let sut = ImageListViewModel(
            imageLoader: MockImageLoader()
        )
        
        guard case .idle = sut.state else {
            return XCTFail("Expected idle state")
        }
    }
    
    func test_fetchImages_setsLoadingState() async {
        let loader = MockImageLoader()
        
        let sut = ImageListViewModel(imageLoader: loader)
        
        await sut.fetchImages()
        
        XCTAssertEqual(loader.getImagesCallCount, 1)
        
        guard case .loading = sut.state else {
            return XCTFail("Expected loading state")
        }
    }
    
    func test_fetchImages_success_callsOnImagesLoaded() async {
        let loader = MockImageLoader()
        
        let images = [
            ImageModel.make(),
            ImageModel.make()
        ]
        
        loader.result = .success(images)
        
        let sut = ImageListViewModel(imageLoader: loader)
        
        var receivedImages: [ImageModel]?
        
        sut.onImagesLoaded = {
            receivedImages = $0
        }
        
        await sut.fetchImages()
        
        XCTAssertEqual(receivedImages?.count, 2)
    }
    
    func test_fetchImages_failure_setsFailureState() async {
        let loader = MockImageLoader()
        
        let error = NSError(
            domain: "Test",
            code: 1
        )
        
        loader.result = .failure(error)
        
        let sut = ImageListViewModel(imageLoader: loader)
        
        await sut.fetchImages()
        
        guard case .failure(let receivedError as NSError) = sut.state else {
            return XCTFail("Expected failure state")
        }
        
        XCTAssertEqual(receivedError.domain, error.domain)
        XCTAssertEqual(receivedError.code, error.code)
    }
    
    func test_fetchImages_whenNotIdle_doesNothing() async {
        let loader = MockImageLoader()
        
        let sut = ImageListViewModel(
            state: .loading,
            imageLoader: loader
        )
        
        await sut.fetchImages()
        
        XCTAssertEqual(loader.getImagesCallCount, 0)
        
        guard case .loading = sut.state else {
            return XCTFail("Expected loading state")
        }
    }
    
    func test_retryLoading_resetsStateAndRetries() async {
        let loader = MockImageLoader()
        
        loader.result = .success([])
        
        let sut = ImageListViewModel(
            state: .failure(NSError(domain: "", code: 1)),
            imageLoader: loader
        )
        
        let expectation = expectation(description: "Images loaded")
        
        sut.onImagesLoaded = { _ in
            expectation.fulfill()
        }
        
        sut.retryLoading()
        
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertEqual(loader.getImagesCallCount, 1)
    }

}

extension ImageModel {

    static func make(
        id: String = UUID().uuidString,
        author: String = "John"
    ) -> ImageModel {
        .init(
            id: id,
            author: author,
            width: 100,
            height: 100,
            url: URL(string: "https://any-url.com")!
        )
    }
}

final class MockImageLoader: ImageLoader {

    var result: Result<[ImageModel], Error> = .success([])
    private(set) var getImagesCallCount = 0

    func getImages() async throws -> [ImageModel] {
        getImagesCallCount += 1
        return try result.get()
    }
}
