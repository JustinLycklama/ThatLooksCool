//
//  LocationIntentHandler.swift
//  TLCIntents
//
//  Created by Justin Lycklama on 2020-12-21.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Intents

import TLCModel
import UserNotifications

class LocationIntentHandler: INExtension, RememberLocationIntentHandling, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    var hasUpdateLocation = false
    var intentCompletion: ((RememberLocationIntentResponse) -> Void)?

    
    func handle(intent: RememberLocationIntent, completion: @escaping (RememberLocationIntentResponse) -> Void) {
        DispatchQueue.main.async {
            self.intentCompletion = completion
            
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if hasUpdateLocation {
            return
        }
        
        hasUpdateLocation = true
        
        guard let coreLocationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            let response = RememberLocationIntentResponse.init(code: .failure, userActivity: nil)
            intentCompletion?(response)
            
            locationManager = nil
            intentCompletion = nil
            
            return
        }

        RealmObjects.shared.addItem(withCoordinate: coreLocationCoordinate) { [weak self] success in
            self?.intentCompletion?(RememberLocationIntentResponse.init(code: success ? .success : .failure, userActivity: nil))
        }
        
        locationManager = nil
        intentCompletion = nil
    }
}
