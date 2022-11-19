//
//  UIView+Additions.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 18/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit
import XCTest

extension UIView {

    /// Find a subview of a specific type which matches an accessibility identifier.
    /// - Parameters:
    ///   - ofType: The type of `UIView` which should be returned
    ///   - identifier: The identifier to match against
    /// - Returns: A `UIView` which matches the given requirements, or nil
    ///  - Note: This is for testing purposes only, not suitable for production code.
    func subview<T: UIView>(ofType: T.Type, withAccessibilityIdentifier identifier: String, file: StaticString = #filePath, line: UInt = #line) -> T? {
        
        allSubviews(isIncluded: { $0.accessibilityIdentifier == identifier }).first as? T
    }

    private func allSubviews(searchRecursively: Bool = true, isIncluded: (UIView) -> Bool) -> [UIView] {

        var matchingSubviews: [UIView] = []

        for subview in subviews {
            if isIncluded(subview) {
                matchingSubviews.append(subview)
            }
            if searchRecursively {
                matchingSubviews.append(contentsOf: subview.allSubviews(searchRecursively: searchRecursively, isIncluded: isIncluded))
            }
        }

        return matchingSubviews
    }
}
