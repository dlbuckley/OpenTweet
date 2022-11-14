//
//  ReadContext.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol ReadContext<T> {

    /// The type on which the ``ReadContext`` operates.
    associatedtype T

    /// Fetch objects of type `T`
    /// - Returns: Objects of type `T`
    func fetch() async throws -> T
}
