//
//  CryptoDetailViewModel.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
import SwiftUI

/// A ViewModel responsible for handling cryptocurrency details.
/// Runs all UI-related updates on the main thread to ensure a smooth user experience.
@MainActor
class CryptoDetailViewModel: ObservableObject {
    @Published var crypto: Crypto
    @Published var priceHistory: [PricePoint] = []
    @Published var isLoadingHistory = false
    @Published var isOffline: Bool = Bool()
    @Published var errorMessage: IdentifiableError?
    
    private let repository: CryptoRepositoryProtocol
    
    /// Initializes the `CryptoDetailViewModel` with a specific cryptocurrency and a repository.
    /// - Parameters:
    ///   - crypto: The `Crypto` model representing the selected cryptocurrency.
    ///   - repository: The repository responsible for fetching and storing cryptocurrency data.
    ///                 Defaults to a new instance of `CryptoRepository` with `CryptoService` and `CryptoPersistence`.
    init(crypto: Crypto, repository: CryptoRepositoryProtocol = CryptoRepository(service: CryptoService(), persistence: CryptoPersistence())) {
        self.crypto = crypto  // Store the selected cryptocurrency
        self.repository = repository // Store the repository instance
    }

    /// Fetches historical price data for the cryptocurrency.
    /// - Parameter days: The number of days for which price history is requested.
    func fetchPriceHistory(days: String) async {
        isLoadingHistory = true
        errorMessage = nil
        do {
            // Fetch historical price data from the API
            let history = try await repository.getPriceHistory(for: crypto.id, days: days)
            // Update the ViewModel with the fetched history
            self.priceHistory = history
            // Save the price history in Core Data for offline access
            repository.savePriceHistory(for: crypto.id, priceHistory: history)
            print("✅ Success fetching history from API")
        } catch {
            print("❌ Error fetching history from API: \(error.localizedDescription)")
            self.errorMessage = IdentifiableError(message: "Failed to load data: \(error.localizedDescription)")
            // If the API request fails, attempt to load data from Core Data
            if let entity = repository.fetchFromCoreData(currency: "usd").first(where: { $0.id == crypto.id }) {
                self.priceHistory = entity.decodePriceHistory() // Decode stored price history
                self.isOffline = true // Mark offline mode
                print("📡 Loaded price history from Core Data")
            } else {
                // No data found in Core Data, display an error message
                self.errorMessage = IdentifiableError(message: "No price history available")
                print("❌ No price history found in Core Data")
            }
        }
        isLoadingHistory = false // Stop loading indicator
    }
}

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
