//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// The ``TimelineViewModel`` is the view model used within the ``TimelineViewController``.
final class TimelineViewModel {

    // MARK: Properties

    /// A ``ReadContext`` which produces ``Tweet``s
    let context: any ReadContext<[Tweet]>

    /// A collection of ``Tweet``s which have been fetched from the ``TimelineViewModel/context``
    private(set) var tweets = [Tweet]()

    // MARK: Initialisers

    /// Create a new ``TimelineViewModel`` with a ``ReadContext`` which produces ``Tweet``s
    /// - Parameter context: A ``ReadContext`` which produces ``Tweet``s
    init(context: any ReadContext<[Tweet]>) {
        self.context = context
    }

    // MARK: Actions

    /// Loads the tweets which populate the timeline
    /// - Returns: A collection of ``Tweet``s to be displayed
    /// - Note: This will also populate the ``TimelineViewModel/tweets`` property
    @discardableResult
    func loadTimeline() async throws -> [Tweet] {
        tweets = try await context.fetch()
        return tweets
    }
}
