//
//  File.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 31/01/25.
//

import SwiftUI

extension View {
    func shimmering(active: Bool) -> some View {
        self.overlay(
            Group {
                if active {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.7), Color.white.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .blendMode(.overlay)
                    .mask(self)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: active)
                }
            }
        )
    }
}
