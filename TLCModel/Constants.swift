//
//  Constants.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2020-12-17.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift

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

            let config = Realm.Configuration(
                fileURL: realmPath,
                
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: 1,
                
                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { migration, oldSchemaVersion in
                
                })
            
            // As we migrate, use migration block to update from version to version
            // Next expected feature is multiple categories
            /*
             if (oldSchemaVersion < 2) {
                 
                 // Schema 0 -> 1: Items can now have multiple categories
                 migration.enumerateObjects(ofType: Item.className()) { oldObject, newObject in
                     // category: ItemCategory?
                     // categories: [ItemCategory]?
                     
                     let category = oldObject?["category"] as? ItemCategory?
                     
                     if let category = category {
                         newObject!["categories"] = [category]
                     }
                 }
             }
             */
            
            return config
        }
    }
}
