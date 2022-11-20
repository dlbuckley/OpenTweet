//
//  NSMutableAttributedString+Additions.swift
//  OpenTweet
//
//  Created by Dale Buckley on 20/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

    /// Adds an attribute with the given name and value to the characters in the specified range.
    /// - Parameters:
    ///   - name: A string specifying the attribute name. Attribute keys can be supplied by another framework or can be custom ones you define. For information about the system-supplied attribute keys, see the Constants section in `NSAttributedString`.
    ///   - value: The attribute value associated with name.
    ///   - ranges: The ranges of characters to which the specified attribute/value pair applies.
    func addAttribute(_ name: NSAttributedString.Key, value: Any, ranges: [NSRange]) {
        ranges.forEach { range in
            addAttribute(.foregroundColor, value: value, range: range)
        }
    }
}
