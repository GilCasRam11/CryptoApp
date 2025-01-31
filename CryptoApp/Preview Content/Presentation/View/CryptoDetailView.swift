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
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                
                Text(viewModel.crypto.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
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
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 3)
                CryptoChartView(priceHistory: $viewModel.priceHistory)
                Spacer()
            }
            .padding()
            
        }
        .navigationTitle(viewModel.crypto.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(days: "7") 
            }
        }
        .refreshable {
            Task {
                await viewModel.fetchPriceHistory(days: "7")
            }
        }
    }
}
