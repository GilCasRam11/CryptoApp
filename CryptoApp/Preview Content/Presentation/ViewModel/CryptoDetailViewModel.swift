//
//  CryptoDetailViewModel.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import Foundation

@MainActor
class CryptoDetailViewModel: ObservableObject {
    @Published var crypto: Crypto
    
    init(crypto: Crypto) {
        self.crypto = crypto
    }
}
