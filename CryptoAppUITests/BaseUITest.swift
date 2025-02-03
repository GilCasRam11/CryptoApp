//
//  BaseUITest.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 01/02/25.
//


import XCTest
@testable import CryptoApp

/// A base class for UI tests using `XCTestCase`.
/// Provides a shared `XCUIApplication` instance for UI test cases.
class BaseUITest: XCTestCase {
    
    /// The application instance that will be launched for UI testing.
    var app: XCUIApplication!

    /// Sets up the test environment before each test case runs.
    /// - Throws: An error if the setup process fails.
    override func setUpWithError() throws {
        // ✅ Stops execution immediately if a failure occurs.
        continueAfterFailure = false

        // ✅ Initializes and launches the application for UI tests.
        app = XCUIApplication()
        app.launch()
    }

    /// Cleans up the test environment after each test case completes.
    /// - Throws: An error if cleanup fails.
    override func tearDownWithError() throws {
        // ✅ Deallocates the application instance after each test.
        app = nil
    }
}

