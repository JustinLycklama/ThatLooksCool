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

public class ResolvedLocation: Object {
    
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

public protocol UnresolvedItem {
    var timestamp: Date? { get }
}

public class UnresolvedLocation: Object, UnresolvedItem {
    @objc public dynamic var coordinate: Coordinate?
    @objc public dynamic let timestamp: Date?
    
    public init(coordinate coord: CLLocationCoordinate2D) {
        coordinate = Coordinate(latitude: coord.latitude, longitude: coord.longitude)
        timestamp = Date()
    }
    
    required override init() {
        coordinate = nil
        timestamp = Date()
    }
}
