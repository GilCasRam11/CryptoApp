//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    /// A shared instance of the Core Data manager to handle data persistence.
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
