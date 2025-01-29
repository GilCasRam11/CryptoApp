//
//  APIClient.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

/// Protocol defining the API client behavior
protocol APIClientProtocol {
    /// Generic function to fetch data from a given URL with optional query parameters
    /// - Parameters:
    ///   - url: The endpoint URL (relative to the base URL)
    ///   - parameters: A dictionary of query parameters to be appended to the URL
    /// - Returns: A decoded object of type `T` conforming to `Decodable`
    /// - Throws: An error if the request fails or decoding is unsuccessful
    func fetch<T: Decodable>(url: String, parameters: [String: String]?) async throws -> T
}

/// Default implementation of the `APIClient` protocol
class APIClient: APIClientProtocol {
    /// Performs an asynchronous network request to fetch data from the given URL
    /// - Parameters:
    ///   - url: The endpoint URL (relative to the base URL)
    ///   - parameters: A dictionary of query parameters to be appended to the request
    /// - Returns: A decoded object of type `T` conforming to `Decodable`
    /// - Throws: An error if the request fails or decoding is unsuccessful
    func fetch<T: Decodable>(url: String, parameters: [String: String]?) async throws -> T {
        // Construct the full URL by appending the endpoint to the base URL
        var components = URLComponents(string: API.baseURL + url)!
        
        // Add query parameters to the URL if available
        components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        // Ensure the final URL is valid
        guard let url = components.url else { throw URLError(.badURL) }

        // Perform the network request asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validate the HTTP response status
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Decode the JSON response into the expected data model
        return try JSONDecoder().decode(T.self, from: data)
    }
}
