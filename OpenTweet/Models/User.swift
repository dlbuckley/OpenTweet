//
//  User.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// A ``User`` is someone who has an account and can perform actions on the platform such as creating content.
struct User: Identifiable {

    /// The type of the Identifier for a ``User``
    typealias Identifier = String

    /// A unique identifier which can be used to reference a ``User``
    let id: Identifier

    /// An optional URL to a ``User``'s avatar image
    let avatarURL: URL?
}
