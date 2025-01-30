//
//  DetailRowView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import SwiftUI

struct DetailRowView: View {
    @State var title: String
    @State var value: Double
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(String(format: "$%.2f", value))
                .font(.subheadline)
                .foregroundColor(value > 0 ? .green : .red)
        }
        .padding(.horizontal)
    }
}
