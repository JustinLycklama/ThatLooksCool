//
//  Location.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift
import CoreLocation

public struct TLC_Constants {
    public static let AppGroupId = "group.com.justinlycklama.ThatLooksCool"
    
    public static var realmPath: URL? {
        get {
            let directoryUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: TLC_Constants.AppGroupId)
            let realmPath = directoryUrl?.appendingPathComponent("db.realm")
            
            return realmPath
        }
    }
    
    public static var realmConfig: Realm.Configuration {
        get {
            var config = Realm.Configuration(fileURL: realmPath)
            config.deleteRealmIfMigrationNeeded = true

            return config
        }
    }
}

public class ResolvedItem: Object {

    @objc public dynamic var title: String?

    @objc public dynamic var coordinate: Coordinate?
    @objc public dynamic var category: ResolvedItemCategory?
    
    public init(pendingItem: PendingItem, category: ResolvedItemCategory) {
        self.title = "Resolved Item From Pending!"
        self.coordinate = pendingItem.coordinate
        self.category = category
    }
    
    public init(category: ResolvedItemCategory) {
        title = "Resolved Item From Nothing"
        self.category = category
    }
    
    required override init() {
        self.title = "??"
        self.coordinate = nil
        self.category = ResolvedItemCategory()
    }
}

public class Coordinate: Object {
    @objc public dynamic var latitude: Double
    @objc public dynamic var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required override init() {
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    /// Computed properties are ignored in Realm
    public var coreLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

//public protocol UnresolvedItem {
//    var timestamp: Date? { get }
//}

public class PendingItem: Object {
    
    @objc public dynamic var title: String?
    @objc public dynamic var coordinate: Coordinate?
    @objc public dynamic let timestamp: Date?
    
    public init(title: String) {
        self.title = title
        timestamp = Date()
    }
    
    public init(coordinate coord: CLLocationCoordinate2D) {
        self.title = ""
        coordinate = Coordinate(latitude: coord.latitude, longitude: coord.longitude)
        timestamp = Date()
    }
    
    required override init() {
        self.title = ""
        coordinate = nil
        timestamp = Date()
    }
}
