//
//  ViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-02.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {

    let GOOGLE_API = "AIzaSyDpgypd8RVgbUFwHqgp80mNzhjGu8Pr2j8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        GMSServices.provideAPIKey(GOOGLE_API)
        GMSPlacesClient.provideAPIKey(GOOGLE_API)
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        
    }


}

