//
//  CryptoListViewUITests.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 01/02/25.
//


import XCTest
@testable import CryptoApp

final class CryptoListViewUITests: BaseUITest {
    
    /// Tests whether the CryptoListView is displayed correctly in the UI.
    func testCryptoListViewDisplaysCorrectly() {
        // Locate the CryptoListView element using its accessibility identifier.
        let cryptoListView = app.otherElements["CryptoListView"]
        
        // Assert that the CryptoListView appears within 5 seconds.
        XCTAssertTrue(cryptoListView.waitForExistence(timeout: 5), "❌ The cryptocurrency list view did not appear.")
        
        print("✅ The cryptocurrency list view loaded correctly.")
    }
    
    /// Tests navigation from the cryptocurrency list to the detail view.
    func testNavigateToCryptoDetailView() {
        // Locate the Bitcoin cell in the crypto list using its accessibility identifier or static text.
        let bitcoinCell = app.staticTexts["Bitcoin"]
        
        // Wait for the Bitcoin cell to appear in the list (up to 10 seconds).
        XCTAssertTrue(bitcoinCell.waitForExistence(timeout: 10), "❌ The Bitcoin cell was not found in the list.")
        
        // Tap on the Bitcoin cell to navigate to the detail view.
        bitcoinCell.tap()
        
        // Locate the CryptoDetailView using its accessibility identifier.
        let detailView = app.otherElements["CryptoDetailView"]
        
        // Wait for the detail view to appear (up to 10 seconds).
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "❌ The detail view did not appear after tapping.")
        
        print("✅ Successfully navigated to the cryptocurrency detail view.")
    }

}
