//
//  CryptoDetailViewModel.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation
import SwiftUI

@MainActor
class CryptoDetailViewModel: ObservableObject {
    @Published var crypto: Crypto
    @Published var priceHistory: [PricePoint] = []
    @Published var isLoadingHistory = false
    @Published var isOffline: Bool = Bool()
    @Published var errorMessage: String?
    
    private let repository: CryptoRepositoryProtocol
    
    init(crypto: Crypto, repository: CryptoRepositoryProtocol = CryptoRepository(service: CryptoService(), persistence: CryptoPersistence())) {
        self.crypto = crypto
        self.repository = repository
    }
    
    func fetchPriceHistory(days: String) async {
        isLoadingHistory = true
        errorMessage = nil
        
        do {
            let history = try await repository.getPriceHistory(for: crypto.id, days: days)
            self.priceHistory = history
            
            // ✅ Guardamos en Core Data si estamos en modo online
            repository.savePriceHistory(for: crypto.id, priceHistory: history)
            
            print("✅ Success fetching history from API")
        } catch {
            print("❌ Error fetching history from API: \(error.localizedDescription)")
            
            // ✅ Si la API falla, intentamos cargar desde Core Data
            if let entity = repository.fetchFromCoreData().first(where: { $0.id == crypto.id }) {
                self.priceHistory = entity.decodePriceHistory()
                self.isOffline = true // ✅ Ahora sí marcamos el modo offline
                print("📡 Loaded price history from Core Data")
            } else {
                self.errorMessage = "No price history available"
                print("❌ No price history found in Core Data")
            }
        }
        
        isLoadingHistory = false
    }
}
