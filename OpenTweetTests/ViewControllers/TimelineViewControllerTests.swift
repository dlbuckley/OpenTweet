//
//  TimelineViewControllerTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class TimelineViewControllerTests: XCTestCase {

    // MARK: SUT Properties

    private var context: MockContext!
    private var viewModel: TimelineViewModel!
    private var controller: TimelineViewController!

    // MARK: Lifecycle

    override func setUpWithError() throws {
        context = MockContext()
        viewModel = TimelineViewModel(context: context)
        controller = TimelineViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        context = nil
        viewModel = nil
        controller = nil
    }

    // MARK: Tests

    func testInitialisation() throws {

        // This is testing that the instance is passed through. We don't want to add `Equatable` conformance to the view model just for the tests as it's never going to be actually used in the project.
        XCTAssertTrue(controller.viewModel === viewModel)
    }

    func testViewModelCalledToLoadTweets() {

        context.mockTweets = [
            Tweet(
                id: "1",
                creationDate: Date.distantFuture,
                author: User(
                    id: "1",
                    avatarURL: nil
                ),
                content: "content",
                inReplyTo: nil
            )
        ]

        let expectation = expectation(description: "Context 'fetch' should be called")

        context.didCallFetch = {
            expectation.fulfill()
        }

        controller.beginAppearanceTransition(true, animated: false)
        controller.endAppearanceTransition()

        waitForExpectations(timeout: 5)
    }
}

// MARK: - Helpers

extension TimelineViewControllerTests {

    private class MockContext: ReadContext {

        var mockTweets: [Tweet] = []
        var didCallFetch: (() -> Void)?

        func fetch() async throws -> [Tweet] {
            didCallFetch?()
            return mockTweets
        }
    }
}
