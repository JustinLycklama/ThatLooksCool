//
//  MapCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-18.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import TLCModel
import GoogleMaps

class MapCell: UITableViewCell {

    @IBOutlet var mapViewArea: UIView!
    
    var mapView: GMSMapView?
    
    var coordinate: Coordinate? {
        didSet {

            layoutPin()

//                self.layoutIfNeeded()

//                mapView?.clear()


//                DispatchQueue.main.async {
//
//
//
//                   let position = CLLocationCoordinate2D(latitude: 32.9483364, longitude: -96.8241543)
//                   let marker = GMSMarker(position: position)
//                   marker.title = "Enter marker title here"
//                   marker.map = self.mapView
//
////                    self.mapView?.animate(toLocation: position)
//
//
////                    let bounds GMSCoordinateBounds(coordinate: position, coordinate: position)
//
//                    self.mapView?.camera = GMSCameraPosition(target: position, zoom: 16, bearing: 0, viewingAngle: 0)
//
//
//
////                    self.mapView.animate(to: GMSCameraPosition(target: position, zoom: 16, bearing: 0, viewingAngle: 0))
////                    self.mapView = GMSMapView(frame: self.mapView.frame, camera: GMSCameraPosition(target: position, zoom: 16, bearing: 0, viewingAngle: 0))
//
//                 }


//                let marker = GMSMarker()
//                marker.position = coordinate
//                marker.map = mapView
//
//                mapView.camera = GMSCameraPosition.init(target: coordinate, zoom: 10)
////                mapView.animate(toZoom: 16) // TODO: Fun zooms?
        }
    }
    
//    override var bounds: CGRect {
//        didSet {
////            if let coordinate = coordinate {
//
//
//
//
//            DispatchQueue.main.async {
//                self.layoutIfNeeded()
//
//                    self.mapView.clear()
//
//                   let position = CLLocationCoordinate2D(latitude: 32.9483364, longitude: -96.8241543)
//                   let marker = GMSMarker(position: position)
//                   self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
//                   marker.title = "Enter marker title here"
//                   marker.map = self.mapView
//                 }
//
////                mapView.camera = GMSCameraPosition.init(target: coordinate.coreLocationCoordinate, zoom: 6)
////            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none

        mapViewArea.layer.borderWidth = 1
        mapViewArea.layer.borderColor = TLCStyle.textBorderColor.cgColor
        mapViewArea.layer.cornerRadius = TLCStyle.textCornerRadius
        
        addMapToView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        layoutPin()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The mapview does not get properly centered when using constraints or when setup after nib load, this is a bit of a hack for now
        if (self.mapView?.frame ?? .zero != self.mapViewArea.bounds) {
            addMapToView(frame: mapViewArea.bounds)
            layoutPin()
        }
    }
    
    private func addMapToView(frame: CGRect) {
        self.mapView?.removeFromSuperview()
        
        let mapView = GMSMapView(frame: frame)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
        mapView.delegate = self
        
        mapView.settings.scrollGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.zoomGestures = false
        
        self.mapView = mapView
        self.mapViewArea.addSubview(mapView)
    }
    
    private func layoutPin() {
        mapView?.clear()
        
        if let coordinate = coordinate?.coreLocationCoordinate {
            let marker = GMSMarker(position: coordinate)
            marker.title = "Enter marker title here"
            marker.map = self.mapView
            
            self.mapView?.camera = GMSCameraPosition(target: coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        }
    }
}

extension MapCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        guard let coordinate = self.coordinate?.coreLocationCoordinate else {
            return
        }
        
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            print("Cannot open maps")
            
            if let urlDestination = URL.init(string: "https://www.google.com/maps/?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)"){
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
}
