//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

protocol CryptoRepositoryProtocol {
    func getCryptos() async throws -> [Crypto]
}

class CryptoRepository: CryptoRepositoryProtocol {
    private let service: CryptoService

    init(service: CryptoService = CryptoService()) {
        self.service = service
    }

    func getCryptos() async throws -> [Crypto] {
        return try await service.fetchCryptos()
    }
}
