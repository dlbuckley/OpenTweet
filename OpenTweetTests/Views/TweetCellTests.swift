//
//  TweetCellTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 19/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class TweetCellTests: XCTestCase {

    // MARK: SUT Properties

    private var cell: TweetCell!

    // MARK: Lifecycle

    override func setUpWithError() throws {

        try super.setUpWithError()

        cell = TweetCell(style: .default, reuseIdentifier: TweetCell.Identifier)
        cell.configure(
            with: mockTweet,
            dateFormatter: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                return dateFormatter
            }()
        )
        cell.layoutIfNeeded()
    }

    override func tearDownWithError() throws {
        cell = nil
        try super.tearDownWithError()
    }

    // MARK: Tests

    func testConfigure() {

        XCTAssertEqual(cell.authorLabel.text, "@spiderman")
        XCTAssertEqual(cell.contentLabel.text, "My spidey senses is tingling!")
        XCTAssertEqual(cell.createdAtLabel.text, "Dec 31, 1")
    }

    func testConfigureUserMentioning() {

        cell.configure(
            with: mockUserMentioningTweet,
            dateFormatter: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                return dateFormatter
            }()
        )

        XCTAssertEqual(cell.authorLabel.text, "@Lion-O")
        XCTAssertEqual(cell.contentLabel.text, "Thunder, thunder, @ThunderCats Ho!")
        var attributeRange = NSRange(location: 18, length: 12)
        XCTAssertNil(cell.contentLabel.attributedText?.attribute(.foregroundColor, at: attributeRange.lowerBound - 1, effectiveRange: nil) as? UIColor)
        XCTAssertEqual(cell.contentLabel.attributedText?.attribute(.foregroundColor, at: 18, effectiveRange: &attributeRange) as? UIColor, UIColor.blue)
        XCTAssertNil(cell.contentLabel.attributedText?.attribute(.foregroundColor, at: attributeRange.upperBound + 1, effectiveRange: nil) as? UIColor)
        XCTAssertEqual(cell.createdAtLabel.text, "Dec 31, 1")
    }

    func testAuthorAboveContent() throws {

        XCTAssertLessThan(cell.authorLabel.frame.maxY, cell.contentLabel.frame.minY)
    }

    func testContentAboveCreatedAtDate() throws {

        XCTAssertLessThan(cell.contentLabel.frame.maxY, cell.createdAtLabel.frame.minY)
    }
}

// MARK: - Helpers

extension TweetCellTests {

    var mockTweet: Tweet {
        Tweet(
            id: "001",
            creationDate: Date.distantPast,
            author: User(
                id: "@spiderman",
                avatarURL: nil
            ),
            content: "My spidey senses is tingling!",
            inReplyTo: nil
        )
    }

    var mockUserMentioningTweet: Tweet {
        Tweet(
            id: "001",
            creationDate: Date.distantPast,
            author: User(
                id: "@Lion-O",
                avatarURL: nil
            ),
            content: "Thunder, thunder, @ThunderCats Ho!",
            inReplyTo: nil
        )
    }
}

// MARK: - View Accessors

extension TweetCell {

    var authorAvatarImageView: UIImageView {
        subview(ofType: UIImageView.self, withAccessibilityIdentifier: "author_avatar_image_view")!
    }

    var authorLabel: UILabel {
        subview(ofType: UILabel.self, withAccessibilityIdentifier: "author_label")!
    }

    var contentLabel: UILabel {
        subview(ofType: UILabel.self, withAccessibilityIdentifier: "content_label")!
    }

    var createdAtLabel: UILabel {
        subview(ofType: UILabel.self, withAccessibilityIdentifier: "created_at_label")!
    }
}
