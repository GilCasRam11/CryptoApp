//
//  CryptoDetailView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//


import SwiftUI

struct CryptoDetailView: View {
    @StateObject var viewModel: CryptoDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: viewModel.crypto.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())

                Text(viewModel.crypto.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Symbol: \(viewModel.crypto.symbol.uppercased())")
                    .font(.title2)
                    .foregroundColor(.gray)

                VStack(spacing: 10) {
                    detailRow(title: "Current Price", value: viewModel.crypto.currentPrice)
                    detailRow(title: "Total Volume", value: viewModel.crypto.totalVolume)
                    detailRow(title: "Highest Price (24h)", value: viewModel.crypto.high24h)
                    detailRow(title: "Lowest Price (24h)", value: viewModel.crypto.low24h)
                    detailRow(title: "Price Change (24h)", value: viewModel.crypto.priceChange24h)
                    detailRow(title: "Market Cap", value: viewModel.crypto.marketCap)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(viewModel.crypto.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(title: String, value: Double) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(String(format: "$%.2f", value)) // Convertimos Double a String con formato
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}
