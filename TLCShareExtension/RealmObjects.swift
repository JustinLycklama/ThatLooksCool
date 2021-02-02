//
//  RealmObjects.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2021-01-25.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import CoreLocation
//import GoogleMaps

import Realm
import RealmSwift

import TLCModel

//public struct ShareExtensionConfig {
//    public static func configure() {
//        GMSServices.provideAPIKey(TLCConfig.apiKey(.maps))
//    }
//}


class RealmObjects {
    internal static let shared = RealmObjects()
  
    public func categorizeItem(_ item: Item, toCategory category: ItemCategory?) {
        let realm: Realm!
        
        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
            
            try realm.write {
                item.isSelectedOutItem = false
                item.updateCategory(category)
            }
        } catch {
            fatalError()
        }
        
        updateNotificationCount(givenRealm: realm)
    }
    
    public func findOutItem(completion: @escaping (Item?) -> Void) {
        let realm: Realm!

        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            completion(nil)
            return
        }

        DispatchQueue.main.async {
            completion(realm.objects(Item.self).filter("isSelectedOutItem == true").list().first)
        }
    }
    
    private func updateNotificationCount(givenRealm realm: Realm) {
        let results = realm.objects(Item.self).filter("category == nil")
        
        // Our application is not open, so we cannot directly modify the badge count
        // send a notification with the new badge count instead
        
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
