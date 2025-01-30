//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//
import SwiftUI

struct CryptoListView: View {
    @StateObject var viewModel = CryptoViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.cryptos) { crypto in
                        NavigationLink(value: crypto) {
                            CryptoRowView(viewModel: viewModel, crypto: crypto)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Cryptocurrencies")
            .navigationDestination(for: Crypto.self) { crypto in
                CryptoDetailView(viewModel: CryptoDetailViewModel(crypto: crypto))
            }
            .refreshable {
                viewModel.fetchCryptos()
            }
        }
        .onAppear {
            if viewModel.cryptos.isEmpty { viewModel.fetchCryptos() }
        }
    }
}


struct CryptoRowView: View {
    @ObservedObject var viewModel: CryptoViewModel
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
                Text(viewModel.formatDate(crypto.lastUpdated))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}
