//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
import CoreData

protocol CryptoRepositoryProtocol {
    func getCryptos(currency: String) async throws -> [Crypto]
    func fetchFromCoreData() -> [CryptoEntity]
}

class CryptoRepository: CryptoRepositoryProtocol {
    private let service: CryptoService
    private let persistence = CryptoPersistence()
    private let context = CoreDataManager.shared.context
    
    init(service: CryptoService = CryptoService()) {
        self.service = service
    }
    
    func getCryptos(currency: String) async throws -> [Crypto] {
        do {
            let cryptos = try await service.fetchCryptos(currency: currency)
            persistence.saveCryptos(cryptos) 
            return cryptos
        } catch {
            print("⚠️ API CryptoRepository Failed, loading from Core Data...")
            throw error   
        }
    }
    func fetchFromCoreData() -> [CryptoEntity] {
        let request: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            print("📡 Core Data fetched \(results.count) items.")
            return results
        } catch {
            print("❌ Error fetching from Core Data: \(error.localizedDescription)")
            return []
        }
    }
}
