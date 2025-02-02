//
//  func.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 30/01/25.
//


import Foundation
import CoreData

extension CryptoEntity {
    /// Creates a fetch request for retrieving `CryptoEntity` objects from Core Data.
    /// - Returns: An `NSFetchRequest` configured to fetch `CryptoEntity` objects.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptoEntity> {
        return NSFetchRequest<CryptoEntity>(entityName: "CryptoEntity")
    }
    
    // MARK: - Core Data Properties
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var lastUpdated: String?
    @NSManaged public var image: String?
    @NSManaged public var totalVolume: Double
    @NSManaged public var high24h: Double
    @NSManaged public var low24h: Double
    @NSManaged public var priceChange24h: Double
    @NSManaged public var marketCap: Double
    @NSManaged public var priceHistory: Data?
}

