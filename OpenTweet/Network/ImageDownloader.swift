//
//  ImageDownloader.swift
//  OpenTweet
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

/// The ``ImageDownloader`` is used to download images from a remote location and will only ever download an image once, even if it's triggered by the same `URL` multiple times.
/// - Note: Inspired by WWDC 2021 session 10133
actor ImageDownloader {

    /// The shared singleton ``ImageDownloader``
    static let shared = ImageDownloader()

    // MARK: Properties

    /// The `URLSession` to use to download images
    let session: URLSession

    private var cache: [URL: CacheEntry] = [:]

    // MARK: Initialisation

    /// Create an ``ImageDownloader`` with the given `URLSession`
    /// - Parameter session: The `URLSession` to use to download images
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: Actions

    /// Download and image from the given `URL`
    /// - Parameter url: The remote `URL` location of the image to download.
    /// - Returns: An optional `UIImage`.
    /// - Note: An image download for a specific URL is only ever triggered once and then cached in memory.
    func image(from url: URL) async throws -> UIImage? {

        // If the URL has already been cached then return either the cached image if it's
        // already been downloaded or await the already running download task if not.
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        let task = Task {
            try await fetchImage(from: url)
        }

        cache[url] = .inProgress(task)

        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }

    // MARK: Private

    private func fetchImage(from url: URL) async throws -> UIImage {

        let (url, _) = try await session.download(from: url)
        let data = try Data(contentsOf: url)

        guard let image = UIImage(data: data) else {
            throw ImageDownloaderError.failedToDecodeImage
        }

        return image
    }
}

// MARK: - Helpers

extension ImageDownloader {

    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
}

// MARK: - Error

extension ImageDownloader {

    enum ImageDownloaderError: Error {

        /// Thrown when trying to decode the downloaded data into a UIImage but it fails possibly due to an unsupported image format or corrupted data
        case failedToDecodeImage
    }
}
