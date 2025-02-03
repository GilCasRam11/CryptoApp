//
//  SplashScreenView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 31/01/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.3
    @State private var scale: CGFloat = 0.5
    var body: some View {
        if isActive {
            CryptoListView()
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 1.2), value: isActive)
        } else {
            ZStack {
                Color.background.ignoresSafeArea().edgesIgnoringSafeArea(.all)
                VStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color(hex: "#00E0FF"))
                        .shadow(color: Color(hex: "#B400FB"), radius: 10)
                        .scaleEffect(scale) // Apply scale animation
                        .opacity(opacity) // Apply opacity animation
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                                scale = 1.0
                                opacity = 1.0
                            }
                        }
                    Text(CryptoLocalizedStrings.cryptoApp)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                opacity = 0.2
                            }
                        }
                }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation { isActive = true }
                    
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
