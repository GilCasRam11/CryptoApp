//
//  CryptoDetailView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import SwiftUI

struct CryptoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CryptoDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 15, height: 25)
                    })
                    Spacer()
                }
                AsyncImage(url: URL(string: viewModel.crypto.image)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(color: Color.init(hex: "00E0FF"), radius: 4, x: 4, y: 5)
                } placeholder: {
                    ProgressView()
                }
                Text(viewModel.crypto.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.init(hex: "edff21"))
                Text(viewModel.crypto.symbol.uppercased())
                    .font(.title2)
                    .foregroundColor(.gray)
                VStack(spacing: 10) {
                    DetailRowView(title: "Current Price", value: viewModel.crypto.currentPrice)
                    DetailRowView(title: "Total Volume", value: viewModel.crypto.totalVolume)
                    DetailRowView(title: "Highest Price (24h)", value: viewModel.crypto.high24h)
                    DetailRowView(title: "Lowest Price (24h)", value: viewModel.crypto.low24h)
                    DetailRowView(title: "Price Change (24h)", value: viewModel.crypto.priceChange24h)
                    DetailRowView(title: "Market Cap", value: viewModel.crypto.marketCap)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                CryptoChartView(priceHistory: $viewModel.priceHistory)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.init(hex: "D3D3D3"))
                    )
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .background(Color.init(hex: "393D42").ignoresSafeArea())
        .alert(item: $viewModel.errorMessage) { error in
                   Alert(title: Text("Error"), message: Text("The history service could not be loaded"), dismissButton: .default(Text("OK")))
               }
        .onAppear {
            // Creates a new asynchronous task to fetch price history data
            Task {
                // Calls the `fetchPriceHistory` method in the ViewModel asynchronously
                // Fetches historical price data for the last 30 days
                await viewModel.fetchPriceHistory(days: "30")
            }
        }
        .refreshable {
            // Creates a new asynchronous task to fetch price history data
            Task {
                await viewModel.fetchPriceHistory(days: "30")
            }
        }
    }
}
