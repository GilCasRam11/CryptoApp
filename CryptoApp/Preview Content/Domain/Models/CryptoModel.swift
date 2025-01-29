//
//  Crypto.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

/// Model representing a cryptocurrency
struct Crypto: Identifiable, Decodable {
    /// Unique identifier of the cryptocurrency
    let id: String
    
    /// Full name of the cryptocurrency (e.g., "Bitcoin")
    let name: String
    
    /// Symbol of the cryptocurrency (e.g., "BTC")
    let symbol: String
    
    /// Current market price of the cryptocurrency
    let currentPrice: Double
    
    /// URL of the cryptocurrency's image or logo
    let image: String

    /// Custom mapping for decoding JSON keys
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case currentPrice = "current_price" // Maps JSON key "current_price" to `currentPrice`
        case image
    }
}
