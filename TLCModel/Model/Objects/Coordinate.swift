//
//  Location.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift
import CoreLocation

public class Coordinate: Object {
    @objc public dynamic var latitude: Double
    @objc public dynamic var longitude: Double

    public init(coreLocationCoordinate: CLLocationCoordinate2D) {
        self.latitude = coreLocationCoordinate.latitude
        self.longitude = coreLocationCoordinate.longitude
    }
    
//    init(latitude: Double, longitude: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
    
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

