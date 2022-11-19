//
//  URLSession+AsyncBridge.swift
//  OpenTweet
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

extension URLSession {

    /// A bridging function which allows retrieving the contents of a URL and delivers the URL of the saved file asynchronously from iOS 13 and up.
    /// - Parameter url: The URL to retrieve
    /// - Returns: An asynchronously-delivered tuple that contains the location of the downloaded file as a `URL`, and a `HTTPURLResponse`.
    func download(from url: URL) async throws -> (URL, HTTPURLResponse) {

        if #available(iOS 15, *) {
            let (url, response) = try await download(from: url, delegate: nil)

            guard let response = response as? HTTPURLResponse else {
                throw URLSessionAsyncBridgeError.unknownResponseType
            }

            return (url, response)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let task = downloadTask(with: URLRequest(url: url)) { url, response, error in

                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let url = url, let response = response else {
                        continuation.resume(throwing: URLSessionAsyncBridgeError.unexpectedOptionalURL)
                        return
                    }

                    guard let response = response as? HTTPURLResponse else {
                        continuation.resume(throwing: URLSessionAsyncBridgeError.unknownResponseType)
                        return
                    }

                    continuation.resume(returning: (url, response))
                }

                task.resume()
            }
        }
    }
}

// MARK: - Error

enum URLSessionAsyncBridgeError: Error {
    case unexpectedOptionalURL
    case unknownResponseType
}
