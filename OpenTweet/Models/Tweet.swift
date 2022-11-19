//
//  Tweet.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

// MARK: - Tweet

/// A ``Tweet`` represents a piece of content broadcast by a user.
struct Tweet: Identifiable {

    /// The type of the Identifier for a ``Tweet``
    typealias Identifier = String

    /// A unique identifier which can be used to reference a ``Tweet``
    let id: Identifier

    /// The date on which the ``Tweet`` was created
    let creationDate: Date

    /// The author of the ``Tweet``
    let author: User

    /// The user created content of the ``Tweet``
    let content: String

    /// An optional ``Tweet/id`` of a ``Tweet`` in which this ``Tweet`` replies to
    let inReplyTo: Identifier?
}

// MARK: - Decodable Conformance

extension Tweet: Decodable {

    /// Keys use to decode a JSON object in to a ``Tweet``
    private enum CodingKeys: String, CodingKey {
        case id
        case creationDate = "date"
        case authorId = "author"
        case content
        case avatarURL = "avatar"
        case inReplyTo
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Identifier.self, forKey: .id)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.content = try container.decode(String.self, forKey: .content)
        self.inReplyTo = try container.decodeIfPresent(Identifier.self, forKey: .inReplyTo)

        // The Author's ID and avatar are inherently linked and so belong in their own object. In the real world we would prefer to see this data not repeated in the payload so we could simply reference the user instead of duplicating entries, but for the sake of this test we will ignore it and simply duplicate the data.
        // We can have a look at the JSONAPI spec as an example of how to include related resources without duplicating their data: https://jsonapi.org/format/#fetching-includes
        self.author = User(
            id: try container.decode(String.self, forKey: .authorId),
            avatarURL: try container.decodeIfPresent(URL.self, forKey: .avatarURL)
        )
    }
}

// MARK: - Hashable Conformance

extension Tweet: Hashable {

    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        // We only really care about the ID for now, we can expand on this later if nessesary
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
