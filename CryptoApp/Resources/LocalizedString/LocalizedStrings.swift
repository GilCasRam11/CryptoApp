//
//  LocalizedStrings.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 01/02/25.


import SwiftUI

struct CryptoLocalizedStrings {
    static var cryptoApp: String {
        return LanguageManager.shared.localizedString(for: "crypto_app", comment: "")
    }
    static var currency: String {
        return LanguageManager.shared.localizedString(for: "currency", comment: "")
    }
    static var offline_mode: String {
        return LanguageManager.shared.localizedString(for: "offline_mode", comment: "Cancel button title")
    }
    static var crypto_currencies: String {
        return LanguageManager.shared.localizedString(for: "crypto_currencies", comment: "")
    }
    static var current_price: String {
        return LanguageManager.shared.localizedString(for: "current_price", comment: "")
    }
    
    static var total_olume: String {
        return LanguageManager.shared.localizedString(for: "total_olume", comment: "")
    }
    static var highest_price: String {
        return LanguageManager.shared.localizedString(for: "highest_price", comment: "")
    }
    static var lowest_price: String {
        return LanguageManager.shared.localizedString(for: "lowest_price", comment: "")
    }
    static var price_change: String {
        return LanguageManager.shared.localizedString(for: "price_change", comment: "")
    }
    static var market_cap: String {
        return LanguageManager.shared.localizedString(for: "market_cap", comment: "")
    }
    static var error: String {
        return LanguageManager.shared.localizedString(for: "error", comment: "")
    }
    static var alert_service_error: String {
        return LanguageManager.shared.localizedString(for: "alert_service_error", comment: "")
    }
    static var ok: String {
        return LanguageManager.shared.localizedString(for: "ok", comment: "")
    }
    static var price_trend: String {
        return LanguageManager.shared.localizedString(for: "price_trend", comment: "")
    }
    static var select_chart_type: String {
        return LanguageManager.shared.localizedString(for: "select_chart_type", comment: "")
    }
    static var search_crypto_by_name: String {
        return LanguageManager.shared.localizedString(for: "search_crypto_by_name", comment: "")
    }
}
