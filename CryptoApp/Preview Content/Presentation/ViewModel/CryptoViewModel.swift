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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: CryptoRepository
    private var fetchTask: Task<Void, Never>?
    
    init(repository: CryptoRepository = CryptoRepository()) {
        self.repository = repository
    }
    
    func fetchCryptos() {
        isLoading = true
        errorMessage = nil
        fetchTask?.cancel()
        
        fetchTask = Task {
            do {
                let cryptosData = try await repository.getCryptos()
                if Task.isCancelled { return }
                
                DispatchQueue.main.async {
                    self.cryptos = cryptosData
                    print("✅ ViewModel updated with \(self.cryptos.count) cryptos")
                }
            } catch {
                if (error as? URLError)?.code != .cancelled {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(error.localizedDescription)"
                        print("❌ ViewModel Error: \(error.localizedDescription)")
                    }
                }
            }
            isLoading = false
        }
    }
}

