//
//  TimelineViewModelTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class TimelineViewModelTests: XCTestCase {

    // MARK: SUT Properties

    private var context: MockContext!
    private var viewModel: TimelineViewModel!

    // MARK: Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
        context = MockContext()
        viewModel = TimelineViewModel(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    // MARK: Tests

    func testInitialisation() throws {

        XCTAssertEqual(viewModel.tweets, [])
    }

    func testFetchSuccess() async throws {

        let tweets = [
            Tweet(
                id: "1",
                creationDate: Date.distantFuture,
                author: User(
                    id: "1",
                    avatarURL: nil
                ),
                content: "tweet 1",
                inReplyTo: nil
            ),
            Tweet(
                id: "99",
                creationDate: Date.distantFuture,
                author: User(
                    id: "89",
                    avatarURL: nil
                ),
                content: "tweet 2",
                inReplyTo: nil
            )
        ]

        context.mockTweets = tweets

        XCTAssertFalse(context.didCallFetch)
        let fetchedTweets = try await viewModel.loadTimeline()
        XCTAssertTrue(context.didCallFetch)

        XCTAssertEqual(fetchedTweets, tweets)
        XCTAssertEqual(viewModel.tweets, tweets)
    }

    func testFetchFailure() async throws {

        context.error = MockError.error

        XCTAssertFalse(context.didCallFetch)
        await XCTAssertThrowsError(try await viewModel.loadTimeline())
        XCTAssertTrue(context.didCallFetch)

        XCTAssertEqual(viewModel.tweets, [])
    }
}

// MARK: - Helpers

extension TimelineViewModelTests {

    private class MockContext: ReadContext {

        var mockTweets: [Tweet] = []
        var error: Error?
        var didCallFetch = false

        func fetch() async throws -> [Tweet] {
            didCallFetch = true
            if let error = error {
                throw error
            } else {
                return mockTweets
            }
        }
    }
}
