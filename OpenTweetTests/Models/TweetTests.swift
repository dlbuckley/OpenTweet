//
//  TweetTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class TweetTests: XCTestCase {

    func testNotReplyingDecodable() throws {

        let tweet = try decodeTweet(fixture: .tweet)

        XCTAssertEqual(tweet.id, "00001")
        XCTAssertEqual(tweet.author.id, "@morty")
        XCTAssertNil(tweet.author.avatarURL)
        XCTAssertEqual(tweet.content, "aww jeez!")
        assertEqualDate(tweet.creationDate, isoDate: "2022-10-14T20:48:00-01:00")
        XCTAssertNil(tweet.inReplyTo)
    }

    func testReplyingTweetDecodable() throws {

        let tweet = try decodeTweet(fixture: .tweetReplyingToTweet)

        XCTAssertEqual(tweet.id, "00088")
        XCTAssertEqual(tweet.author.id, "@martymcfly")
        XCTAssertNil(tweet.author.avatarURL)
        XCTAssertEqual(tweet.content, "Okay, relax, Doc! It's me, it's me! It's Marty.")
        assertEqualDate(tweet.creationDate, isoDate: "2020-09-29T14:41:00-08:00")
        XCTAssertEqual(tweet.inReplyTo, "00042")
    }
}

// MARK: - Helper Functionality

extension TweetTests {

    private func decodeTweet(fixture: Fixture, decoder: JSONDecoder = JSONDecoder()) throws -> Tweet {

        let data = Data.load(fixture: fixture)
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(Tweet.self, from: data)
    }

    /// A convenience method to aid in testing on iOS 14
    private func assertEqualDate(_ date: Date, isoDate: String, file: StaticString = #filePath, line: UInt = #line) {

        if #available(iOS 15.0, *) {
            XCTAssertEqual(date, try! Date(isoDate, strategy: .iso8601), file: file, line: line)
        } else {
            // TODO: Remove once iOS 14 support is dropped
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let creationDate = dateFormatter.date(from: isoDate)!
            XCTAssertEqual(date, creationDate, file: file, line: line)
        }
    }
}
