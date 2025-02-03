//
//  CryptoViewModel.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

/// A ViewModel responsible for handling cryptocurrency details.
/// Runs all UI-related updates on the main thread to ensure a smooth user experience.
@MainActor
class CryptoViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var coreDataCryptos: [CryptoEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCurrency: String = "usd"
    @Published var isOffline: Bool = Bool()
    @Published var searchText: String = ""
    
    private let repository: CryptoRepositoryProtocol
    
    /// Returns a filtered list of cryptocurrencies based on the search text.
    /// - If `searchText` is empty:
    ///     - If in **offline mode** (`isOffline == true`), return data from Core Data.
    ///     - Otherwise, return the full list of cryptocurrencies fetched from the API.
    /// - If `searchText` is **not empty**, filter the list based on name or symbol.
    var filteredCryptos: [Crypto] {
        if searchText.isEmpty {
            // If search text is empty, return full list based on online/offline mode
            return isOffline ? coreDataCryptos.map { $0.toCrypto() } : cryptos
        } else {
            // Filter cryptos based on name or symbol (case insensitive)
            return cryptos.filter { crypto in
                crypto.name.lowercased().contains(searchText.lowercased()) ||
                crypto.symbol.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    /// Initializes the ViewModel with a repository for handling cryptocurrency data.
    /// - Parameter repository: The repository responsible for fetching and storing cryptocurrency data.
    ///                         Defaults to a new instance of `CryptoRepository`.
    init(repository: CryptoRepositoryProtocol = CryptoRepository()) {
        self.repository = repository
    }
    
    /// Fetches cryptocurrency data from the API and falls back to Core Data if the API request fails.
    func fetchCryptos() async {
        isLoading = true
        errorMessage = nil
        print("🌍 Fetching cryptos...")
        do {
            // Attempt to fetch data from the API
            let cryptosData = try await repository.getCryptos(currency: selectedCurrency)
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.cryptos = cryptosData // Update fetched cryptos
                self.coreDataCryptos = [] // Clear any previously loaded Core Data results
                self.isOffline = false // Mark as online mode
                print("✅ Data loaded from API, isOffline: \(self.isOffline)")
                print("✅ ViewModel loaded \(self.cryptos.count) cryptos")
            }
        } catch {
            // Handle API failure by loading from Core Data
            DispatchQueue.main.async {
                let coreDataCryptos = self.repository.fetchFromCoreData()
                if coreDataCryptos.isEmpty {
                    // No data available in Core Data
                    self.errorMessage = "No data available"
                    self.isOffline = false
                    print("❌ No data in Core Data, setting isOffline: \(self.isOffline)")
                } else {
                    // Load data from Core Data instead
                    self.coreDataCryptos = coreDataCryptos
                    self.cryptos = coreDataCryptos.map { $0.toCrypto() }
                    self.isOffline = true // Mark as offline mode
                    self.errorMessage = nil
                    print("📡 Loaded from Core Data, isOffline: \(self.isOffline), Items: \(coreDataCryptos.count)")
                }
                print("⚠️ Failed to fetch from API, loading from Core Data. isOffline: \(self.isOffline)")
                print("❌ ViewModel Error: \(error.localizedDescription)")
            }
        }
        //TODO: Is just to see the skeleton
        //Delay for UI skeleton loading effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false //Stop loading indicator
        }
    }
    
    /// Converts an ISO 8601 date string into a human-readable format.
    /// - Parameter dateString: The date string in ISO 8601 format.
    /// - Returns: A formatted date string (e.g., "Jan 10, 2024 at 3:45 PM") or `"N/A"` if the input is invalid.
    func formatDate(_ dateString: String) -> String {
        // Create an ISO8601DateFormatter to parse the input string
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Handles full ISO format including milliseconds
        // Convert the ISO string to a Date object
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium // Formats as "Jan 10, 2024"
            formatter.timeStyle = .short  // Includes time, e.g., "3:45 PM"
            
            return formatter.string(from: date) // Return the formatted date string
        }
        return "N/A" // Return "N/A" if parsing fails
    }
}
