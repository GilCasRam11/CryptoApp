//
//  CryptoPersistence.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 30/01/25.
//


import CoreData

class CryptoPersistence {
    private let context = CoreDataManager.shared.context
    
    func saveCryptos(_ cryptos: [Crypto]) {
        let context = CoreDataManager.shared.context
        
        for crypto in cryptos {
            let fetchRequest: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", crypto.id)
            CoreDataManager.shared.saveContext()
            do {
                let existingCryptos = try context.fetch(fetchRequest)
                if existingCryptos.isEmpty {
                    let entity = CryptoEntity(context: context)
                    entity.id = crypto.id
                    entity.name = crypto.name
                    entity.symbol = crypto.symbol
                    entity.currentPrice = crypto.currentPrice
                    entity.lastUpdated = crypto.lastUpdated
                    entity.image = crypto.image
                    entity.totalVolume = crypto.totalVolume
                    entity.high24h = crypto.high24h
                    entity.low24h = crypto.low24h
                    entity.priceChange24h = crypto.priceChange24h
                    entity.marketCap = crypto.marketCap
                }
            } catch {
                print("❌ Error checking for existing CryptoEntity: \(error.localizedDescription)")
            }
        }
        
        do {
            try context.save()
            print("✅ Core Data saved \(cryptos.count) new items (duplicates avoided).")
        } catch {
            print("❌ Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    func fetchCryptos() -> [Crypto] {
        let request: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            let cryptos = results.map { entity in
                Crypto(
                    id: entity.id ?? "",
                    name: entity.name ?? "",
                    symbol: entity.symbol ?? "",
                    currentPrice: entity.currentPrice,
                    lastUpdated: entity.lastUpdated ?? "",
                    image: entity.image ?? "",
                    totalVolume: entity.totalVolume,
                    high24h: entity.high24h,
                    low24h: entity.low24h,
                    priceChange24h: entity.priceChange24h,
                    marketCap: entity.marketCap
                )
            }
            print("📡 Core Data fetched \(cryptos.count) items.")
            return cryptos
        } catch {
            print("❌ Error fetching data from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearData() {
        let request: NSFetchRequest<NSFetchRequestResult> = CryptoEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🗑 Core Data cleared before saving new data.")
        } catch {
            print("❌ Error clearing Core Data: \(error.localizedDescription)")
        }
    }
}

extension CryptoEntity {
    func toCrypto() -> Crypto {
        return Crypto(
            id: self.id ?? "",
            name: self.name ?? "",
            symbol: self.symbol ?? "",
            currentPrice: self.currentPrice,
            lastUpdated: self.lastUpdated ?? "",
            image: self.image ?? "",
            totalVolume: self.totalVolume,
            high24h: self.high24h,
            low24h: self.low24h,
            priceChange24h: self.priceChange24h,
            marketCap: self.marketCap
        )
    }
}
