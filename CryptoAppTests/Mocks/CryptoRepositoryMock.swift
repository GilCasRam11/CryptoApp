//
//  CryptoRepositoryMock.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
@testable import CryptoApp

/// A mock implementation of `CryptoRepositoryProtocol` for testing purposes.
class CryptoRepositoryMock: CryptoRepositoryProtocol {
    /// Determines whether the mock repository should simulate a failure.
    /// - If `true`, the repository will throw an error instead of returning mock data.
    /// - If `false`, it will return predefined cryptocurrency data.
    var shouldFail = false
    var storedCryptos: [Crypto] = []
    var storedPriceHistory: [String: [PricePoint]] = [:]
    
    /// Simulates fetching cryptocurrency data for testing purposes.
    /// - Parameter currency: The currency in which the cryptocurrency prices should be returned.
    /// - Returns: A predefined array of `Crypto` objects.
    /// - Throws: A `URLError` if `shouldFail` is set to `true` (simulating an API failure).
    func getCryptos(currency: String) async throws -> [Crypto] {
        // Simulate network delay (100 milliseconds)
        try await Task.sleep(nanoseconds: 100_000_000)
        // Simulate an API failure scenario
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        // Mock cryptocurrency data
        let mockData = [
            Crypto(
                id: "bitcoin",
                name: "Bitcoin",
                symbol: "btc",
                currentPrice: 105101.0,
                lastUpdated: "2025-01-30T04:30:37.280Z",
                image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
                totalVolume: 37943173266.0,
                high24h: 105266.0,
                low24h: 101447.0,
                priceChange24h: 2976.48,
                marketCap: 2083415543404.0
            )
        ]
        // Store mock data for later use
        storedCryptos = mockData
        print("✅ Mock Repository is returning \(mockData.count) cryptos")
        return mockData
    }
    
    /// Simulates fetching stored cryptocurrency data from Core Data.
    /// - Returns: An empty array (or mock `CryptoEntity` objects if needed).
    func fetchFromCoreData(currency: String) -> [CryptoEntity] {
        return []
    }
    
    /// Simulates fetching historical price data for a cryptocurrency.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency.
    ///   - days: The number of days for which price history is requested.
    /// - Returns: A predefined array of `PricePoint` objects representing the historical price data.
    /// - Throws: A `URLError` if `shouldFail` is set to `true`, simulating an API failure.
    func getPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint] {
        // Simulate network delay (100 milliseconds)
        try await Task.sleep(nanoseconds: 100_000_000)
        // Simulate an API failure scenario
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        // Generate mock price history data for the last 3 days
        let history = [
            PricePoint(date: Date().addingTimeInterval(-86400 * 3), price: 100000.0), // 3 days ago
            PricePoint(date: Date().addingTimeInterval(-86400 * 2), price: 102000.0), // 2 days ago
            PricePoint(date: Date().addingTimeInterval(-86400 * 1), price: 104000.0)  // 1 day ago
        ]
        // Store mock data for later use (if needed)
        storedPriceHistory[cryptoId] = history
        print("✅ Mock Repository returning history for \(cryptoId)")
        return history
    }
    
    /// Simulates saving historical price data for a cryptocurrency.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency.
    ///   - priceHistory: An array of `PricePoint` objects representing the historical price data.
    func savePriceHistory(for cryptoId: String, priceHistory: [PricePoint]) {
        // Store the provided price history in the mock dictionary
        storedPriceHistory[cryptoId] = priceHistory
        // Log the action for debugging
        print("✅ Mock Repository saved price history for \(cryptoId)")
    }
}
