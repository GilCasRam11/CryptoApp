//
//  Crypto.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import Foundation

struct Crypto: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let lastUpdated: String
    let image: String
    let totalVolume: Double
    let high24h: Double
    let low24h: Double
    let priceChange24h: Double
    let marketCap: Double
    var priceHistory: [PricePoint]?
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case lastUpdated = "last_updated"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case marketCap = "market_cap"
        case priceHistory = "prices"
    }
}

struct PricePoint: Identifiable, Codable, Hashable {
    var id = UUID()
    let date: Date
    let price: Double
}
