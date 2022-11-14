//
//  Fixtures.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

// MARK: - Fixture

/// A `Fixture` represents a piece of data which can be read from disk and used for testing a particular scenario
enum Fixture: String {

    case empty = "Empty"
    case timelineDTO = "TimelineDTOFixture"
    case tweet = "TweetFixture"
    case tweetReplyingToTweet = "TweetReplyingToTweetFixture"
}

// MARK: - Fixture related URL extension

extension URL {

    init(fixture: Fixture, bundle: Bundle = .testBundle) {

        guard let url = bundle.url(forResource: fixture.rawValue, withExtension: "json") else {
            fatalError("Unable to find resource '\(fixture.rawValue)'. Please check that the resource is included in the testing bundle.")
        }

        self = url
    }
}
// MARK: - Fixture related Data extension

extension Data {

    /// Load data for a given `Fixture`
    /// - Parameter fixture: The `Fixture` which represents the testing data to be returned
    /// - Returns: The `Data` for the given `Fixture`
    /// - Note: This a synchronous blocking function which reads from the disk.
    static func load(fixture: Fixture) -> Data {

        let url = URL(fixture: fixture)

        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Unable to load fixture data from '\(url)': \(error)")
        }
    }
}

// MARK: - Test Bundle Convenience

private class BundleFinder { }

extension Foundation.Bundle {

    /// Convenience accessor for the test bundle.
    static let testBundle: Bundle = Bundle(for: BundleFinder.self)
}
