//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 29/01/25.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    let persistenceController = CoreDataManager.shared
    var body: some Scene {
        WindowGroup {
            CryptoListView()
                .environment(\.managedObjectContext, persistenceController.context) 
        }
    }
}
