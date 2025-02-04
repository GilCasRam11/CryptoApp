//
//  CryptoPersistence.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 30/01/25.
//

import CoreData

/// Manages the persistence of cryptocurrency data using Core Data.
class CryptoPersistence {
    /// Reference to the shared Core Data context.
    private let context = CoreDataManager.shared.context
    /// Saves an array of `Crypto` objects to Core Data.
    /// - Parameter cryptos: An array of `Crypto` objects to be stored in the database.
    func saveCryptos(_ cryptos: [Crypto], currency: String) {
//        clearData()
        let context = CoreDataManager.shared.context
        for crypto in cryptos {
            // Create a fetch request to check if the cryptocurrency already exists in Core Data
            let fetchRequest: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@ AND currency == %@", crypto.id, currency)
            CoreDataManager.shared.saveContext() // Ensure any previous changes are saved
            
            do {
                // Fetch existing records with the same `id`
                let existingCryptos = try context.fetch(fetchRequest)
                // If no existing record is found, create a new entity
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
                    entity.currency = currency
                    
                    // Check if price history is available before saving
                    if crypto.priceHistory?.isEmpty ?? true {
//                        print("⚠️ Not saving priceHistory for \(crypto.name) because it's empty")
                    } else {
                        // Encode `priceHistory` into `Data` before saving
                        if let encodedHistory = try? JSONEncoder().encode(crypto.priceHistory) {
                            entity.setValue(encodedHistory, forKey: "priceHistory")
                            print("✅ Price history saved for \(crypto.name): \(String(describing: crypto.priceHistory?.count)) points")
                        } else {
                            print("❌ Failed to encode priceHistory for \(crypto.name)")
                        }
                    }
                }
            } catch {
                print("❌ Error checking for existing CryptoEntity: \(error.localizedDescription)")
            }
        }
        // Attempt to save all new entities to Core Data
        do {
            try context.save()
            print("✅ Core Data saved \(cryptos.count) new items (duplicates avoided).")
        } catch {
            print("❌ Error saving to Core Data: \(error.localizedDescription)")
        }
    }

    /// Fetches all stored cryptocurrencies from Core Data and converts them into `Crypto` model objects.
    /// - Returns: An array of `Crypto` objects retrieved from Core Data.
    func fetchCryptos() -> [Crypto] {
        // Create a fetch request for `CryptoEntity`
        let request: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        do {
            // Fetch the stored data from Core Data
            let results = try context.fetch(request)
            // Convert `CryptoEntity` objects into `Crypto` model instances
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
                    marketCap: entity.marketCap,
                    priceHistory: entity.decodePriceHistory(),
                    currency: entity.currency ?? ""
                )
            }
            print("📡 Core Data fetched \(cryptos.count) items.")
            return cryptos // Return the list of converted `Crypto` objects
        } catch {
            print("❌ Error fetching data from Core Data: \(error.localizedDescription)")
            return [] // Return an empty array in case of failure
        }
    }

    /// Deletes all stored cryptocurrency data from Core Data.
    func clearData() {
        // Create a fetch request targeting all `CryptoEntity` objects
        let request: NSFetchRequest<NSFetchRequestResult> = CryptoEntity.fetchRequest()
        // Create a batch delete request to remove all matching entities
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            // Execute the batch delete request
            try context.execute(deleteRequest)
            // Save changes to persist the deletion
            try context.save()
            print("🗑 Core Data cleared before saving new data.")
        } catch {
            // Log any errors that occur during the deletion process
            print("❌ Error clearing Core Data: \(error.localizedDescription)")
        }
    }
}

extension CryptoEntity {
    /// Converts a `CryptoEntity` (Core Data object) into a `Crypto` model.
    /// - Returns: A `Crypto` object with all stored attributes mapped correctly.
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
            marketCap: self.marketCap,
            priceHistory: self.priceHistoryDecoded,
            currency: self.currency
        )
    }
    /// Decodes the stored `priceHistory` from Core Data into an array of `PricePoint`.
    /// - Returns: An array of `PricePoint` objects representing the historical price data.
    func decodePriceHistory() -> [PricePoint] {
        // Attempt to retrieve and decode the price history from stored Core Data `Data`
        guard let data = self.value(forKey: "priceHistory") as? Data else {
            print("⚠️ No price history data found in Core Data for \(self.name ?? "Unknown")")
            return []
        }
        do {
            let decodedHistory = try JSONDecoder().decode([PricePoint].self, from: data)
            print("📡 Price history loaded for \(self.name ?? "Unknown"): \(decodedHistory.count) points")
            return decodedHistory
        } catch {
            print("❌ Error decoding priceHistory: \(error.localizedDescription)")
            return []
        }
    }
    /// Computed property that returns the decoded price history.
    var priceHistoryDecoded: [PricePoint] {
        return decodePriceHistory()
    }
}

