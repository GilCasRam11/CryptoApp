//
//  Crypto.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let lastUpdated: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case lastUpdated = "last_updated"
    }
}

