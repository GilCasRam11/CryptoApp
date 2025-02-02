//
//  LanguageManager.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 01/02/25.
//

import Foundation

class LanguageManager {
    // Singleton instance of LanguageManager
    static let shared = LanguageManager()

    // Private initializer to prevent instantiation from other classes
    private init() {}

    /// Retrieves a localized string for a given key.
    /// - Parameters:
    ///   - key: The key for the localized string in the .strings file.
    ///   - comment: An optional comment describing the usage of the string (default is an empty string).
    /// - Returns: The localized string corresponding to the provided key.
    func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}

