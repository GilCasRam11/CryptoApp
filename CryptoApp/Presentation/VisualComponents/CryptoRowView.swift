//
//  CryptoRowView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import SwiftUI

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
                    .foregroundColor(Color.init(hex: "b7b3ae"))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$\(crypto.currentPrice, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
                Text(viewModel.formatDate(crypto.lastUpdated))
                    .font(.footnote)
                    .foregroundColor(Color.init(hex: "b7b3ae"))
            }
        }.padding()
            .background(RoundedRectangle(cornerRadius: 12).fill()
            .foregroundStyle(Color.init(hex: "2f4f4f"))
            .shadow(color: Color.init(hex: "B400FB"), radius: 3, x: 3, y: 5)
        )
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}
