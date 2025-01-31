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
    func getPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint]
    func savePriceHistory(for cryptoId: String, priceHistory: [PricePoint])
}

class CryptoRepository: CryptoRepositoryProtocol {
    private let service: CryptoService
    private var persistence = CryptoPersistence()
    private let context = CoreDataManager.shared.context
    
    init(service: CryptoService = CryptoService(), persistence: CryptoPersistence = CryptoPersistence()) {
        self.service = service
        self.persistence = persistence
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
    
    func getPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint] {
        return try await service.fetchPriceHistory(for: cryptoId, days: days)
    }
    
    func savePriceHistory(for cryptoId: String, priceHistory: [PricePoint]) {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", cryptoId)
        
        do {
            let existingCryptos = try context.fetch(fetchRequest)
            
            if let entity = existingCryptos.first {
                if let encodedData = try? JSONEncoder().encode(priceHistory) {
                    entity.priceHistory = encodedData
                }
            }
            
            try context.save()
            print("✅ Core Data saved price history for \(cryptoId)")
        } catch {
            print("❌ Error saving price history to Core Data: \(error.localizedDescription)")
        }
    }
}
