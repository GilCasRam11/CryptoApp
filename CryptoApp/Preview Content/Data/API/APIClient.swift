//
//  APIClient.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

protocol APIClient {
    func fetch<T: Decodable>(url: String, parameters: [String: String]?) async throws -> T
}

class DefaultAPIClient: APIClient {
    func fetch<T: Decodable>(url: String, parameters: [String: String]?) async throws -> T {
        var components = URLComponents(string: API.baseURL + url)!
        components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
