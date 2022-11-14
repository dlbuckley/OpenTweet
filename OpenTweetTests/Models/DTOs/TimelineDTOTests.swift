//
//  TimelineDTOTests.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

final class TimelineDTOTests: XCTestCase {

    func testDecodableSuccess() throws {

        let data = Data.load(fixture: .timelineDTO)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let timelineDTO = try decoder.decode(TimelineDTO.self, from: data)

        XCTAssertEqual(timelineDTO.tweets.count, 3)
    }
}
