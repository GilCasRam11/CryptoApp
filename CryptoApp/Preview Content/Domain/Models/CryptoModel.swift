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

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case lastUpdated = "last_updated"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case marketCap = "market_cap"
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        symbol = try container.decode(String.self, forKey: .symbol)
//        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
//        image = try container.decode(String.self, forKey: .image)
//        totalVolume = try container.decode(Double.self, forKey: .totalVolume)
//        high24h = try container.decode(Double.self, forKey: .high24h)
//        low24h = try container.decode(Double.self, forKey: .low24h)
//        priceChange24h = try container.decode(Double.self, forKey: .priceChange24h)
//        marketCap = try container.decode(Double.self, forKey: .marketCap)
//
//        let dateString = try container.decode(String.self, forKey: .lastUpdated)
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        lastUpdated = isoFormatter.date(from: dateString) ?? Date()
//    }
}


