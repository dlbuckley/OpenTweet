//
//  String+AdditionsTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 20/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

// -----------------------------
// These are just some basic tests and not comprehensive due to time limitations
// -----------------------------

final class String_AdditionsTests: XCTestCase {

    // MARK: `userMentionRanges` tests

    func testUserMentionAtBeginning() {

        let matches = "@author check this out!".userMentionRanges()

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.0, NSRange(location: 0, length: 7))
        XCTAssertEqual(matches.first?.1, "@author")
    }

    func testUserMentionInMiddle() {

        let matches = "Hey @author, check this out!".userMentionRanges()

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.0, NSRange(location: 4, length: 7))
        XCTAssertEqual(matches.first?.1, "@author")
    }

    func testUserMentionInEnd() {

        let matches = "I really can't believe you @author".userMentionRanges()

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.0, NSRange(location: 27, length: 7))
        XCTAssertEqual(matches.first?.1, "@author")
    }

    func testUserMentionMultiple() {

        let matches = "Hey @author, did you see what @other_user did?".userMentionRanges()

        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches.first?.0, NSRange(location: 4, length: 7))
        XCTAssertEqual(matches.first?.1, "@author")
        XCTAssertEqual(matches.last?.0, NSRange(location: 30, length: 11))
        XCTAssertEqual(matches.last?.1, "@other_user")
    }

    // MARK: `urlRanges` tests

    func testURLRanges() {

        let matches = "This is hilarious https://twitter.com".urlRanges()

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.0, NSRange(location: 18, length: 19))
        XCTAssertEqual(matches.first?.1, URL(string: "https://twitter.com")!)
    }
}
