//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//
import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel = CryptoViewModel()
    @FetchRequest(
        entity: CryptoEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CryptoEntity.marketCap, ascending: false)]
    ) private var storedCryptos: FetchedResults<CryptoEntity>
    @Environment(\.managedObjectContext) private var context
    var body: some View {
        NavigationStack {
            
            VStack {
                TextField("Search Crypto", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker("Currency", selection: $viewModel.selectedCurrency) {
                    Text("USD ($)").tag("usd")
                    Text("EUR (€)").tag("eur")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedCurrency, {
                    Task { await viewModel.fetchCryptos() }
                })
                if viewModel.isOffline {
                    Text("Offline Mode")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(5)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(5)
                        .onAppear { print("🟠 Offline Mode UI Updated") }
                }
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List {
                        if viewModel.isOffline {
                            ForEach(viewModel.filteredCryptos, id: \.self) { cryptoEntity in
                                NavigationLink(value: cryptoEntity) {
                                    CryptoRowView(viewModel: viewModel, crypto: cryptoEntity)
                                }
                            }
                        } else {
                            ForEach(viewModel.filteredCryptos) { crypto in
                                NavigationLink(value: crypto) {
                                    CryptoRowView(viewModel: viewModel, crypto: crypto)
                                }
                            }
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
                Task {
                    await viewModel.fetchCryptos()
                }
            }
        }
        .task {
            await viewModel.fetchCryptos()
        }
    }
}
