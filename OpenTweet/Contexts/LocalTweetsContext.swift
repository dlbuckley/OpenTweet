//
//  LocalTweetsContext.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

// MARK: - LocalTweetsContext

/// Manage tweets stored on the local device
final class LocalTweetsContext {

    // MARK: Properties

    /// The location of the file which contains the tweet timeline
    let url: URL

    /// The bundle from which to find the timeline file
    let bundle: Bundle

    /// The `JSONDecoder` which will be used to decode the timeline data
    let decoder: JSONDecoder

    // MARK: Initialisers

    /// Create a ``LocalTweetsContext`` with the location of the local file.
    /// - Parameters:
    ///   - url: The location of the file which contains the tweet timeline
    ///   - bundle: The bundle from which to find the timeline file (default: main)
    ///   - decoder: The `JSONDecoder` which will be used to decode the timeline data (default: nil)
    /// - Note: The decoder will be created automatically with a `dateDecodingStrategy` of `iso8601` if one is not passed.
    init(url: URL, bundle: Bundle = .main, decoder: JSONDecoder? = nil) {
        self.url = url
        self.bundle = bundle
        self.decoder = decoder ?? {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
    }
}

// MARK: - Convenience Initialisers

extension LocalTweetsContext {

    convenience init() {

        let bundle = Bundle.main

        guard let url = bundle.url(forResource: "timeline", withExtension: "json") else {
            // We trigger a fatal error here as this is a developer issue the app cannot recover from.
            fatalError("Unable to find local `timeline.json` resource. Please check that the resource is included in the main bundle.")
        }

        self.init(url: url, bundle: bundle)
    }
}

// MARK: - ReadContext Conformance

extension LocalTweetsContext: ReadContext {

    /// Asynchronously fetch an unordered collection of ``Tweet``s.
    /// - Returns: An unordered collection of ``Tweet``s.
    func fetch() async throws -> [Tweet] {

        let data = try Data(contentsOf: url)
        let timelineDTO = try decoder.decode(TimelineDTO.self, from: data)

        return timelineDTO.tweets
    }
}
