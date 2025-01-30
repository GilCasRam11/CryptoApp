//
//  CryptoRepositoryMock.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
@testable import CryptoApp

class CryptoRepositoryMock: CryptoRepositoryProtocol {
    var shouldFail = false

    func getCryptos() async throws -> [Crypto] {
        try await Task.sleep(nanoseconds: 100_000_000)
        
        if shouldFail {
            throw URLError(.badServerResponse)
        }

        
        let mockData = [
                    Crypto(id: "bitcoin",
                           name: "Bitcoin",
                           symbol: "btc",
                           currentPrice: 105101.0,
                           lastUpdated: "2025-01-30T04:30:37.280Z",
                           image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
                           totalVolume: 37943173266.0,
                           high24h: 105266.0,
                           low24h: 101447.0,
                           priceChange24h: 2976.48,
                           marketCap: 2083415543404.0)
                ]

                print("✅ Mock Repository is returning \(mockData.count) cryptos")
                return mockData
    }
}
