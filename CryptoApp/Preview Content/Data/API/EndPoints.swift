//
//  EndPoints.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import Foundation
/// Defines API-related constants
enum API {
    /// The base URL for the CoinGecko API
    static let baseURL = "https://api.coingecko.com/api/v3"
    /// Nested enum to group API endpoints
    enum Endpoints {
        /// Endpoint for retrieving cryptocurrency market data
        static let cryptoMarkets = "/coins/markets"
    }
    static func priceHistory(cryptoId: String, days: String) -> String {
        return "https://api.coingecko.com/api/v3/coins/\(cryptoId)/market_chart?vs_currency=usd&days=\(days)"
    }
}
