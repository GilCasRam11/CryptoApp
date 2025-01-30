//
//  CryptoViewModel.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

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
    var filteredCryptos: [Crypto] {
        if searchText.isEmpty {
            return isOffline ? coreDataCryptos.map { $0.toCrypto() } : cryptos
        } else {
            return cryptos.filter { crypto in
                crypto.name.lowercased().contains(searchText.lowercased()) ||
                crypto.symbol.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    
    init(repository: CryptoRepositoryProtocol = CryptoRepository()) {
        self.repository = repository
    }
    
    func fetchCryptos() async {
        isLoading = true
        errorMessage = nil
        print("🔄 Fetching cryptos...")
        do {
            let cryptosData = try await repository.getCryptos(currency: selectedCurrency)
            DispatchQueue.main.async {
                self.cryptos = cryptosData
                self.coreDataCryptos = []
                self.isOffline = false
                print("✅ Data loaded from API, isOffline: \(self.isOffline)")
                print("✅ ViewModel loaded \(self.cryptos.count) cryptos")
            }
        } catch {
            DispatchQueue.main.async {
                let coreDataCryptos = self.repository.fetchFromCoreData()
                if coreDataCryptos.isEmpty {
                    self.errorMessage = "No data available"
                    self.isOffline = false
                    print("❌ No data in Core Data, setting isOffline: \(self.isOffline)")
                } else {
                    self.coreDataCryptos = coreDataCryptos
                    self.cryptos = coreDataCryptos.map { $0.toCrypto() }
                    self.isOffline = true
                    self.errorMessage = nil
                    print("📡 Loaded from Core Data, isOffline: \(self.isOffline), Items: \(coreDataCryptos.count)")
                }
                print("⚠️ Failed to fetch from API, loading from Core Data. isOffline: \(self.isOffline)")
                print("❌ ViewModel Error: \(error.localizedDescription)")
            }
        }
        
        isLoading = false
    }
    
    func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        return "N/A"
    }
}
