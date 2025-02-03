# CryptoApp

📌 Project Description

Crypto App is an iOS application developed with SwiftUI, allowing users to view up-to-date cryptocurrency information using the CoinGecko API. It follows Clean Architecture and MVVM, ensuring a modular and maintainable codebase.

# Architecture

The project follows the Clean Architecture pattern with MVVM, dividing the application into well-defined layers:

🟢 Presentation Layer (UI)
* Contains SwiftUI Views (View) and ViewModels (ObservableObject).
* CryptoListView, CryptoDetailView, CryptoChartView manage the UI.
* ViewModels control the UI state and use Combine to update data.
  
🔵 Domain Layer (Business Logic)
* Contains the business logic of the application.
* CryptoModel and PricePoint define the data models.
* Defines the repository protocols (CryptoRepositoryProtocol).
* Uses UseCases for logic separation.

🟠 Data Layer (Data Management)
* Implements data fetching from API and Core Data.
* APIClient manages HTTP requests.
* CryptoPersistence and CoreDataManager handle local data storage.
* CryptoRepository is the repository implementation that connects API and Core Data.

# Technologies Used

* SwiftUI - Declarative UI framework.
* Combine - Reactive programming for event handling.
* Core Data - Local data persistence.
* Clean Architecture - Modular architecture with responsibility separation.
* Swift Concurrency (async/await) - Modern asynchronous operations.
* XCTest - Unit testing with mocks.
*CoinGecko API (for cryptocurrency data)

# Installation and Execution

1️⃣ Clone the repository

git clone https://github.com/your-repository.git

cd CryptoApp

2️⃣ Run the project in Xcode

Open CryptoApp.xcworkspace in Xcode.

Select a simulator or physical device.

Press CMD + R to run the application.

# Main Features

✅ Cryptocurrency list with updated prices.

✅ Detailed view of each cryptocurrency with price history.

✅ Offline mode with Core Data (allows viewing data without an internet connection).

✅ Search cryptocurrencies with SearchBar.

✅ Currency switch (USD/EUR) with UI selection.

✅ Charts to display price trends.

# Requirements 

* Requires Xcode 14+ and Swift 5.7+.
* Select a simulator with iOS 16+.

# Unit and UI Testing

📍 Unit Tests (XCTest)

Run unit tests with the following command:

CMD + U

Unit tests include:

Mock Repository: CryptoRepositoryMock.

API tests: Validation of API calls.

Data validation in Core Data.

📍 UI Tests (XCTest UI Tests)

UI Tests validate navigation and UI functionality.

Run UI Tests with:

CMD + U  # Runs all UI and unit tests

```
func testNavigateToCryptoDetailView() {
 
        let bitcoinCell = app.staticTexts["Bitcoin"
        
        XCTAssertTrue(bitcoinCell.waitForExistence(timeout: 10), "❌ The Bitcoin cell was not found in the list.")
        
        bitcoinCell.tap()
        let detailView = app.otherElements["CryptoDetailView"]
        
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "❌ The detail view did not appear after tapping.")
        
       print("✅ Successfully navigated to the cryptocurrency detail view.")
       
    }
```

# Thank you

Thank you for checking out Crypto App! 

If you have suggestions or improvements, feel free to contribute. 🤝
