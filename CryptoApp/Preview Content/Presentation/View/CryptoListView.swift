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
        sortDescriptors: [NSSortDescriptor(keyPath: \CryptoEntity.marketCap, ascending: true)]
    ) private var storedCryptos: FetchedResults<CryptoEntity>
    @Environment(\.managedObjectContext) private var context
   
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Currency", selection: $viewModel.selectedCurrency) {
                    Text("💲 USD").tag("usd")
                    Text("💶 EUR").tag("eur")
                    Text("🇲🇽 MXN").tag("mxn")
                    Text("💷 GBP").tag("gbp")
                }
                .background(Color.init(hex: "343e40"))
                .cornerRadius(9)
                .shadow(color: Color.init(hex: "00E0FF"), radius: 2, x: 2, y: 3)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedCurrency, {
                    Task { await viewModel.fetchCryptos() }
                })
                if viewModel.isOffline {
                    Text("Offline Mode")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(5)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
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
                    }.padding(.bottom, 10)
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
            .background(Color.init(hex: "393D42").ignoresSafeArea())
            .navigationTitle("Crypto currencies")
            .navigationDestination(for: Crypto.self) { crypto in
                CryptoDetailView(viewModel: CryptoDetailViewModel(crypto: crypto))
            }
            .refreshable {
                // Creates a new asynchronous task to fetch price history data
                Task {
                    await viewModel.fetchCryptos()
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search crypto by name")
        }
        // Creates a new asynchronous task to fetch price history data
        .task {
            await viewModel.fetchCryptos()
        }
       
    }
}
