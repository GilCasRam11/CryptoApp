//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//
import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel = CryptoViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.cryptos) { crypto in
                        CryptoRowView(crypto: crypto)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Cryptocurrencies")
            .refreshable {
                viewModel.fetchCryptos()  // Quitamos 'await'
            }
        }
        .onAppear {
            if viewModel.cryptos.isEmpty { viewModel.fetchCryptos() }  // No usar `.task {}`
        }
    }
}


struct CryptoRowView: View {
    let crypto: Crypto
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: crypto.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(crypto.name)
                    .font(.headline)
                Text(crypto.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(crypto.currentPrice, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
                Text(formatDate(crypto.lastUpdated))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Soporta milisegundos
        
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        return "N/A"
    }
}
