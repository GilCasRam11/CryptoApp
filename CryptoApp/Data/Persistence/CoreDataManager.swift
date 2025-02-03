//
//  CoreDataManager.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 30/01/25.
//

import CoreData

/// Singleton class responsible for managing Core Data operations.
class CoreDataManager {
    /// Shared instance of `CoreDataManager` to ensure a single Core Data stack is used throughout the app.
    static let shared = CoreDataManager()
    /// Persistent container for managing Core Data storage.
    let container: NSPersistentContainer
    /// Managed object context used for performing Core Data operations.
    var context: NSManagedObjectContext { container.viewContext }
    
    /// Private initializer to prevent multiple instances and ensure singleton pattern.
    private init() {
        // Initialize the persistent container with the Core Data model name
        container = NSPersistentContainer(name: "CryptoEntity")
        // Load the persistent store asynchronously
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }
    
    /// Saves changes in the managed object context to the persistent store.
    func saveContext() {
        // Check if there are any unsaved changes
        if context.hasChanges {
            do {
                try context.save() // Attempt to save the changes
            } catch {
                print("❌ Error saving Core Data: \(error.localizedDescription)")
            }
        }
    }
}

