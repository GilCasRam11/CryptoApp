import XCTest
@testable import CryptoApp

final class CryptoRepositoryTests: XCTestCase {
    /// Mock repository instance used for testing.
    var repository: CryptoRepositoryMock!
    /// Sets up the test environment before each test case runs.
    override func setUp() {
        super.setUp()
        // Initialize the mock repository before each test
        repository = CryptoRepositoryMock()
    }
    /// Cleans up the test environment after each test case completes.
    override func tearDown() {
        repository = nil
        super.tearDown() //Call superclass teardown method
    }
    
    /// Tests the successful retrieval of cryptocurrency data from the mock repository.
    func testGetCryptos_Success() async {
        do {
            // Call the mock repository to fetch cryptos
            let cryptos = try await repository.getCryptos(currency: "usd")
            // Verify that one crypto is returned
            XCTAssertEqual(cryptos.count, 1, "Expected 1 crypto but got \(cryptos.count)")
            // Validate that the first crypto has the expected ID and name
            XCTAssertEqual(cryptos.first?.id, "bitcoin", "Expected ID to be 'bitcoin'")
            XCTAssertEqual(cryptos.first?.name, "Bitcoin", "Expected name to be 'Bitcoin'")
            print("✅ testGetCryptos_Success passed")
        } catch {
            // Fail the test if an error occurs
            XCTFail("❌ testGetCryptos_Success failed: \(error)")
        }
    }
    
    /// Tests the failure scenario when fetching cryptocurrency data from the mock repository.
    func testGetCryptos_Failure() async {
        // Simulate an API failure by setting `shouldFail` to true
        repository.shouldFail = true
        do {
            // Attempt to fetch cryptos (expected to fail)
            _ = try await repository.getCryptos(currency: "usd")
            // ❌ If the function does not throw an error, the test should fail
            XCTFail("❌ testGetCryptos_Failure should have thrown an error")
        } catch {
            // Verify that the error type is `URLError.badServerResponse`
            XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse, "Expected badServerResponse error")
            print("✅ testGetCryptos_Failure passed")
        }
    }
    
    /// Tests the successful retrieval of price history data from the mock repository.
    func testGetPriceHistory_Success() async {
        do {
            // Fetch mock price history for Bitcoin over the last 7 days
            let history = try await repository.getPriceHistory(for: "bitcoin", days: "7")
            // Verify that the returned price history contains 3 entries
            XCTAssertEqual(history.count, 3, "Expected 3 historical price points but got \(history.count)")
            // Ensure the first price point matches the expected value
            XCTAssertEqual(history.first?.price, 100000.0, "Expected first price point to be 100000.0")
            print("✅ testGetPriceHistory_Success passed")
        } catch {
            // If an error occurs, the test should fail
            XCTFail("❌ testGetPriceHistory_Success failed: \(error)")
        }
    }
    
    /// Tests the failure scenario when fetching price history data from the mock repository.
    func testGetPriceHistory_Failure() async {
        // Simulate an API failure by setting `shouldFail` to true
        repository.shouldFail = true
        do {
            // Attempt to fetch price history (expected to fail)
            _ = try await repository.getPriceHistory(for: "bitcoin", days: "7")
            // If the function does not throw an error, the test should fail
            XCTFail("❌ testGetPriceHistory_Failure should have thrown an error")
        } catch {
            // Verify that the error type is `URLError.badServerResponse`
            XCTAssertEqual((error as? URLError)?.code, URLError.badServerResponse, "Expected badServerResponse error")
            print("✅ testGetPriceHistory_Failure passed")
        }
    }
}
