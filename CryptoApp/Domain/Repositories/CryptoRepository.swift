//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
import CoreData

/// Defines the contract for a cryptocurrency repository, handling both API and local Core Data operations.
protocol CryptoRepositoryProtocol {
    /// Fetches cryptocurrency data from an API.
    /// - Parameter currency: The currency in which the cryptocurrency prices should be returned (e.g., "usd").
    /// - Returns: An array of `Crypto` objects containing market data.
    /// - Throws: An error if the API request fails or data decoding is unsuccessful.
    func getCryptos(currency: String) async throws -> [Crypto]
    
    /// Retrieves stored cryptocurrency entities from Core Data.
    /// - Returns: An array of `CryptoEntity` objects fetched from Core Data.
    func fetchFromCoreData(currency: String) -> [CryptoEntity]
    
    /// Fetches historical price data for a given cryptocurrency.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency (e.g., "bitcoin").
    ///   - days: The number of days for which price history is requested.
    /// - Returns: An array of `PricePoint` objects representing the historical price data.
    /// - Throws: An error if the API request fails or the response cannot be parsed.
    func getPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint]
    
    /// Saves the historical price data for a given cryptocurrency in Core Data.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency.
    ///   - priceHistory: An array of `PricePoint` objects representing the historical price data.
    func savePriceHistory(for cryptoId: String, priceHistory: [PricePoint])
}


/// Repository class responsible for handling cryptocurrency data retrieval and persistence.
class CryptoRepository: CryptoRepositoryProtocol {
    
    /// The service responsible for making API requests.
    private let service: CryptoService
    
    /// Core Data persistence manager for storing and retrieving data.
    private var persistence = CryptoPersistence()
    
    /// Reference to the Core Data context.
    private let context = CoreDataManager.shared.context
    
    /// Initializes the repository with a service and persistence layer.
    /// - Parameters:
    ///   - service: The API service for fetching cryptocurrency data. Defaults to a new `CryptoService` instance.
    ///   - persistence: The persistence manager for handling Core Data operations. Defaults to a new `CryptoPersistence` instance.
    init(service: CryptoService = CryptoService(), persistence: CryptoPersistence = CryptoPersistence()) {
        self.service = service
        self.persistence = persistence
    }
    
    /// Fetches cryptocurrency data from the API and saves it to Core Data.
    /// - Parameter currency: The currency in which the cryptocurrency prices should be returned (e.g., "usd").
    /// - Returns: An array of `Crypto` objects.
    /// - Throws: An error if the API request fails.
    func getCryptos(currency: String) async throws -> [Crypto] {
        do {
            // Fetch cryptocurrency data from the API
            let cryptos = try await service.fetchCryptos(currency: currency)
            // Save the fetched data to Core Data for offline access
            persistence.saveCryptos(cryptos, currency: currency)
            // Return the retrieved cryptocurrency list
            return cryptos
        } catch {
            // Log an error message and throw the error if the API request fails
            print("⚠️ API CryptoRepository Failed, loading from Core Data...")
            throw error
        }
    }
    
    /// Fetches all stored cryptocurrency entities from Core Data.
    /// - Returns: An array of `CryptoEntity` objects.
    func fetchFromCoreData(currency: String) -> [CryptoEntity] {
        // Create a fetch request to retrieve all stored `CryptoEntity` objects
        let request: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "currency == %@", currency)
        do {
            // Execute the fetch request
            let results = try context.fetch(request)
            print("📡 Core Data fetched \(results.count) items.")
            print("📡 Core Data fetched \(results.count) items for currency: \(currency)")
            return results // Return the fetched entities
        } catch {
            print("❌ Error fetching from Core Data: \(error.localizedDescription)")
            return [] // Return an empty array in case of an error
        }
    }

    /// Fetches historical price data for a specific cryptocurrency from the API.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency (e.g., "bitcoin").
    ///   - days: The number of days for which price history is requested.
    /// - Returns: An array of `PricePoint` objects representing the historical price data.
    /// - Throws: An error if the API request fails.
    func getPriceHistory(for cryptoId: String, days: String) async throws -> [PricePoint] {
        // Fetch historical price data from the API
        return try await service.fetchPriceHistory(for: cryptoId, days: days)
    }
    
    /// Saves the historical price data for a specific cryptocurrency in Core Data.
    /// - Parameters:
    ///   - cryptoId: The unique identifier of the cryptocurrency.
    ///   - priceHistory: An array of `PricePoint` objects representing the historical price data.
    func savePriceHistory(for cryptoId: String, priceHistory: [PricePoint]) {
        let context = CoreDataManager.shared.context
        // Create a fetch request to find the corresponding `CryptoEntity` in Core Data
        let fetchRequest: NSFetchRequest<CryptoEntity> = CryptoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", cryptoId) // Filter by crypto ID
        do {
            // Fetch existing cryptocurrency entity
            let existingCryptos = try context.fetch(fetchRequest)
            if let entity = existingCryptos.first {
                // Encode `priceHistory` into `Data` for storage in Core Data
                if let encodedData = try? JSONEncoder().encode(priceHistory) {
                    entity.priceHistory = encodedData
                }
            }
            // Save the updated entity to Core Data
            try context.save()
            print("✅ Core Data saved price history for \(cryptoId)")
        } catch {
            print("❌ Error saving price history to Core Data: \(error.localizedDescription)")
        }
    }
}
