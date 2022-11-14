//
//  Timeline.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

// MARK: - Timeline

/// The ``TimelineDTO`` is a 'Data Transfer Object' used to ease the decoding of a timeline payload using `Decodable`. It's raw use is limited as the ``Tweet`` objects it contains are of an unordered nature.
struct TimelineDTO {

    /// An unordered collection of ``Tweet``s
    let tweets: [Tweet]
}

// MARK: - Decodable Conformance

extension TimelineDTO: Decodable {

    /// Keys use to decode a JSON object in to a ``Timeline``
    private enum CodingKeys: CodingKey {
        case timeline
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tweets = try container.decode([Tweet].self, forKey: .timeline)
    }
}
