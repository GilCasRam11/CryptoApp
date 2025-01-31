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
    
    /// Fetches a list of cryptocurrencies from the API
    /// - Returns: An array of `Crypto` objects
    /// - Throws: An error if the request fails or decoding is unsuccessful
    func fetchCryptos(currency: String) async throws -> [Crypto] {
        // Define query parameters for the API request
        let parameters = [
            "vs_currency": currency,  // Specify currency in which prices are fetched
            "per_page": "20",      // Limit the number of results per page
            "page": "1"            // Request the first page of results
        ]
        
        do {
            let cryptos: [Crypto] = try await apiClient.fetch(url: API.Endpoints.cryptoMarkets, parameters: parameters)
            print("✅ Cryptos loaded successfully: \(cryptos.count)")
            return cryptos
        } catch {
            print("❌ Error fetching cryptos: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint] {
        let urlString = API.priceHistory(cryptoId: cryptoId, days: days)
        
        let historyData: [String: [[Double]]] = try await apiClient.fetchPriceHistory(url: urlString, parameters: nil)
        
        guard let prices = historyData["prices"] else {
            throw URLError(.cannotParseResponse)
        }
        
        return prices.compactMap { priceEntry in
            guard priceEntry.count == 2 else { return nil }
            let date = Date(timeIntervalSince1970: priceEntry[0] / 1000)
            return PricePoint(date: date, price: priceEntry[1])
        }
    }
}

