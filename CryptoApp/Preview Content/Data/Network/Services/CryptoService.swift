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
    func fetchCryptos() async throws -> [Crypto]
}

/// Default implementation of the `CryptoService` protocol
class CryptoService: CryptoServiceProtocol {
    /// Instance of `APIClient` to handle API requests
    private let apiClient: APIClient

    /// Initializes the service with an API client
    /// - Parameter apiClient: An instance of `APIClient`, defaults to `DefaultAPIClient`
    init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }

    /// Fetches a list of cryptocurrencies from the API
    /// - Returns: An array of `Crypto` objects
    /// - Throws: An error if the request fails or decoding is unsuccessful
    func fetchCryptos() async throws -> [Crypto] {
        // Define query parameters for the API request
        let parameters = [
            "vs_currency": "usd",  // Specify currency in which prices are fetched
            "per_page": "20",      // Limit the number of results per page
            "page": "1"            // Request the first page of results
        ]

        // Fetch data from the API and return the decoded array of `Crypto` objects
        return try await apiClient.fetch(url: API.Endpoints.cryptoMarkets, parameters: parameters)
    }
}
