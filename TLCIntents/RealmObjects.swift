//
//  RealmObjects.swift
//  TLCIntents
//
//  Created by Justin Lycklama on 2020-12-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import CoreLocation

import Realm
import RealmSwift

import TLCModel

class RealmObjects {
    internal static let shared = RealmObjects()
    
    internal func addItem(withCoordinate coreLocationCoordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void) {
        let realm: Realm!
        
        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            completion(false)
            return
        }
            
        let coordinate = Coordinate(coreLocationCoordinate: coreLocationCoordinate)
        
        do {
            try realm.write {
                realm.add(Item(coordinate: coordinate))
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    internal func addItem(withPhrase phrase: String, completion: @escaping (Bool) -> Void) {
        let realm: Realm!
        
        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            completion(false)
            return
        }
        
        do {
            try realm.write {
                realm.add(Item(title: phrase))
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    private func updateNotificationCount(givenRealm realm: Realm) {
        let results = realm.objects(Item.self).filter("category == nil")
        
        let content = UNMutableNotificationContent()
        content.sound = .none
        content.badge = NSNumber(value: results.count)
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
