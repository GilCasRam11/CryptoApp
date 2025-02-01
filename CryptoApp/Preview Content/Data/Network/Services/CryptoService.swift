//
//  CryptoService.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

/// Protocol defining the behavior of a cryptocurrency service
protocol CryptoServiceProtocol {
    /// Fetches a list of cryptocurrencies
    /// - Returns: An array of `Crypto` objects
    /// - Throws: An error if the request fails or data decoding is unsuccessful
    func fetchCryptos(currency: String) async throws -> [Crypto]
    func fetchPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint]
}

/// Default implementation of the `CryptoService` protocol
class CryptoService: CryptoServiceProtocol {
    /// Instance of `APIClient` to handle API requests
    private let apiClient: APIClient
    
    /// Initializes the service with an API client
    /// - Parameter apiClient: An instance of `APIClient`, defaults to `DefaultAPIClient`
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    /// Fetches a list of cryptocurrencies and their market data.
    /// - Parameter currency: The currency in which the cryptocurrency values should be returned (e.g., "usd").
    /// - Returns: An array of `Crypto` objects.
    /// - Throws: An error if the network request fails or data decoding is unsuccessful.
    func fetchCryptos(currency: String) async throws -> [Crypto] {
        // Define query parameters for the API request
        let parameters = [
            "vs_currency": currency, // Specify the currency for the market data
            "per_page": "20",        // Limit the number of results per page
            "page": "1"              // Request the first page of results
        ]
        do {
            // Make an asynchronous API request using the API client
            let cryptos: [Crypto] = try await apiClient.fetch(url: API.Endpoints.cryptoMarkets, parameters: parameters)
            print("✅ Cryptos loaded successfully: \(cryptos.count)")
            
            // Return the fetched cryptocurrencies
            return cryptos
            
        } catch {
            print("❌ Error fetching cryptos: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Fetches historical price data for a specific cryptocurrency.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency (e.g., "bitcoin").
    ///   - days: The number of days for which price history is requested.
    /// - Returns: An array of `PricePoint` objects representing the historical prices.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    func fetchPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint] {
        
        // Construct the API URL for fetching price history
        let urlString = API.priceHistory(cryptoId: cryptoId, days: days)
        
        // Fetch price history data from the API, expecting a dictionary with an array of price points
        let historyData: [String: [[Double]]] = try await apiClient.fetchPriceHistory(url: urlString, parameters: nil)
        
        // Ensure that the "prices" key exists in the response data
        guard let prices = historyData["prices"] else {
            throw URLError(.cannotParseResponse) // Throw an error if the expected data is missing
        }
        
        // Convert raw price data into an array of `PricePoint` objects
        return prices.compactMap { priceEntry in
            guard priceEntry.count == 2 else { return nil } // Ensure each entry contains exactly two values
            
            let date = Date(timeIntervalSince1970: priceEntry[0] / 1000) // Convert timestamp to Date
            return PricePoint(date: date, price: priceEntry[1]) // Create and return a `PricePoint` instance
        }
    }
}

