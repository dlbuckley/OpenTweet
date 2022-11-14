//
//  LocalTweetsContextTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class LocalTweetsContextTests: XCTestCase {

    func testFetchSuccess() async throws {

        let context = LocalTweetsContext(url: URL(fixture: .timelineDTO), bundle: .testBundle)
        let tweets = try await context.fetch()

        XCTAssertEqual(tweets.count, 3)
        XCTAssertEqual(tweets.first?.id, "00001")
        XCTAssertEqual(tweets.last?.id, "00003")
    }

    func testFetchEmptyData() async throws {

        let context = LocalTweetsContext(url: URL(fixture: .empty), bundle: .testBundle)
        await XCTAssertThrowsError(try await context.fetch())
    }

    func testConvenienceInitialiserSuccess() async throws {

        let context = LocalTweetsContext()
        let tweets = try await context.fetch()

        XCTAssertEqual(tweets.count, 7)
    }
}
