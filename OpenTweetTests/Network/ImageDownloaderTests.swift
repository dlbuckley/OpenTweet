//
//  ImageDownloaderTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class ImageDownloaderTests: XCTestCase {

    // MARK: SUT Properties

    private var imageDownloader: ImageDownloader!

    // MARK: Lifecycle

    override func setUpWithError() throws {

        try super.setUpWithError()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        imageDownloader = ImageDownloader(session: URLSession(configuration: configuration))
    }

    override func tearDownWithError() throws {
        imageDownloader = nil
        MockURLProtocol.loadRequest = nil
        try super.tearDownWithError()
    }

    // MARK: Tests

    func testDownloadImageSuccess() async throws {

        MockURLProtocol.loadRequest = { request in
            (
                data: Data.load(fixture: .mockImageFixture),
                response: HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                ),
                error: nil
            )
        }

        let image = try await imageDownloader.image(from: URL(string: "http://test.com")!)

        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size, CGSize(width: 360, height: 360))
    }

    func testDownloadImageFailure() async throws {

        MockURLProtocol.loadRequest = { request in
            (
                data: nil,
                response: nil,
                error: URLError(.badURL)
            )
        }

        await XCTAssertThrowsError(try await imageDownloader.image(from: URL(string: "http://test.com")!))
    }

    func testDownloadImageOnlyOnce() async throws {

        let expectation = expectation(description: "Image download triggered only once")

        // Both these are set by default, but they are explicitly set to make the test easier to understand and reason about
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        MockURLProtocol.loadRequest = { request in
            expectation.fulfill()
            return (
                data: Data.load(fixture: .mockImageFixture),
                response: HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                ),
                error: nil
            )
        }

        let image1 = try await imageDownloader.image(from: URL(string: "http://test.com")!)
        let image2 = try await imageDownloader.image(from: URL(string: "http://test.com")!)

        await waitForExpectations(timeout: 4)

        XCTAssertEqual(image1, image2)
    }
}

// MARK: - Helpers

extension ImageDownloaderTests {

    final class MockURLProtocol: URLProtocol {

        static var loadRequest: ((URLRequest) -> (data: Data?, response: URLResponse?, error: Error?))?

        static var requests: [URLRequest] = []

        override class func canInit(with request: URLRequest) -> Bool {
            MockURLProtocol.requests.append(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {

            guard let request = MockURLProtocol.requests.last else {
                fatalError("No requests available to act upon. Ensure requests are stored in to `requests` before `startLoading` is called.")
            }

            guard let loadRequest = MockURLProtocol.loadRequest else {
                fatalError("'loadRequest' must be set to handle mocking a response")
            }

            let result = loadRequest(request)

            if let data = result.data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            if let response = result.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = result.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }

            self.client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() { }
    }
}
