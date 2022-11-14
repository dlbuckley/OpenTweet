//
//  XCTest+Additions.swift
//  OpenTweetTests
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import XCTest

extension XCTest {

    /// Asserts that an expression throws an error asynchronously.
    /// - Parameters:
    ///   - expression: An expression that can throw an error.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    ///   - errorHandler: An optional handler for errors that expression throws.
    ///
    ///   - Note: This is modelled on XCTAssertThrowsError which is not asynchronous. This internal implementation is a best guess to mirror it's functionality.
    func XCTAssertThrowsError<T: Sendable>(_ expression: @autoclosure () async throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line, _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
