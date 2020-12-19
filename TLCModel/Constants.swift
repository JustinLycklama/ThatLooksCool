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
            var config = Realm.Configuration(fileURL: realmPath)
            config.deleteRealmIfMigrationNeeded = true

            return config
        }
    }
}
