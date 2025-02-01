//
//  ColorExtension.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 31/01/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        switch hex.count {
        case 6: // RGB (Ejemplo: #FF5733)
            (a, r, g, b) = (1, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        case 8: // ARGB (Ejemplo: #80FF5733)
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0) // Color negro por defecto en caso de error
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
