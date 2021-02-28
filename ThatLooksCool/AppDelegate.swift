//
//  AppDelegate.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-02.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import MapKit

import Firebase
import GoogleMobileAds

import TLCModel
import ClassicClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        TLCConfig.configure()
//
        Classic.setAppStyle(TLCStyle.shared)
        
//        ShareExtensionConfig.configure()
        
        TLCIconSet.register()
        TLCCategoryIconSet.register()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
            if success {
                print("Badge authorized")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        UINavigationBar.appearance().barTintColor = TLCStyle.navBarBackgroundColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: TLCStyle.navBarFont ?? UIFont.systemFont(ofSize: 24),
                                                            NSAttributedString.Key.foregroundColor: TLCStyle.navBarTextColor]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().isHidden = true

        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: TLCStyle.barButtonFont ?? UIFont.systemFont(ofSize: 14),
                                                             NSAttributedString.Key.foregroundColor: TLCStyle.barButtonTextColor], for: .normal)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
