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
    
    var body: some View {
        if isActive {
            CryptoListView()
        } else {
            ZStack {
                Color.init(hex: "393D42").edgesIgnoringSafeArea(.all)
                VStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color(hex: "#00E0FF"))
                        .shadow(color: Color(hex: "#B400FB"), radius: 10)
                    
                    Text("CryptoApp")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                opacity = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}
