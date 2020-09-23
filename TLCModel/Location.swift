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
    @objc dynamic var latitude: Double
    @objc dynamic var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init() {
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
    var timestamp: Date? { get set }
}

public class UnresolvedLocation: Object, UnresolvedItem {
    @objc public dynamic var coordinates: Coordinate?
    @objc public dynamic var timestamp: Date?
    
    public init(coordinate: CLLocationCoordinate2D) {
        coordinates = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        timestamp = Date()
    }
    
    required init() {
        timestamp = Date()
    }
}
