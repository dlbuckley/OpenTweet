//
//  String+Additions.swift
//  OpenTweet
//
//  Created by Dale Buckley on 20/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {

    /// Matches any user mentions within the `String`.
    /// - Returns: An array containing tuples with the location and ``User/Identifier`` of the matching user mentions.
    func userMentionRanges() -> [(NSRange, User.Identifier)] {

        // Adding iOS 16 specific code using the new `Regex` so the older method is simply a fallback and can be removed later.
        if #available(iOS 16, *) {
            let ranges = ranges(of: /@[\w\d]+/)
            let nsRanges = ranges.map { NSRange($0, in: self) }
            let userIdentifiers = ranges.map { String(self[$0]) }
            return Array(zip(nsRanges, userIdentifiers))
        } else {
            let ranges = ranges(of: "@[\\w\\d]+")
            let userIdentifiers = ranges.map {
                let startIndex = self.index(self.startIndex, offsetBy: $0.lowerBound)
                let endIndex = self.index(self.startIndex, offsetBy: $0.upperBound)
                return String(self[startIndex..<endIndex])
            }
            return Array(zip(ranges, userIdentifiers))
        }
    }

    /// Matches any URLs within the `String`.
    /// - Returns: An array containing tuples with the location and `URL` of the matching urls.
    func urlRanges() -> [(NSRange, URL)] {
        do {
            // Match URLs with `NSDataDetector`
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            // Extract the ranges and URLs
            let ranges = matches.map { $0.range }
            let urls = ranges.compactMap {
                let startIndex = self.index(self.startIndex, offsetBy: $0.lowerBound)
                let endIndex = self.index(self.startIndex, offsetBy: $0.upperBound)
                return URL(string: String(self[startIndex..<endIndex]))
            }

            // Zip up the arrays in to a tuple for easy consumption
            return Array(zip(ranges, urls))
        } catch {
            // If we hit an issue we want to fail elegantly and just not match anything as this is not a critical code path
            print("An issue occurred when attempting to match URLs in a string: \(error)")
            return []
        }
    }

    /// Finds and returns the ranges of the all occurrences of a given sequence within the `String`.
    /// - Parameter pattern: The regex to search for.
    /// - Returns: A collection or ranges in the receiver of all occurrences of regex. Returns an empty collection if regex is not found.
    /// - Warning: This is simply a bridging method for iOS versions **BELOW** iOS 16.
    ///
    /// For iOS 16 and above use the new `Regex` function of a similar name but with regex pattern standards checking `func ranges(of regex: some RegexComponent) -> [Range<Self.Index>]`.
    /// - Note: The `@available(*, deprecated)` just adds an annoying warning even within an `if #available(iOS 16, *)` check, so its been avoided here.
    func ranges(of pattern: String) -> [NSRange] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            return matches.map { $0.range }
        } catch {
            return []
        }
    }
}
