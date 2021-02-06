//
//  MapCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-18.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import GoogleMaps

import TLCModel
import ClassicClient

class MapCell: UITableViewCell {

    private let mapZoom: Float = 17
    
    private let mapViewArea = UIView()
    
    var mapView: GMSMapView?
    
    private let mapStyleJSON = "[\r\n    {\r\n      \"featureType\": \"poi\",\r\n      \"stylers\": [\r\n        { \"visibility\": \"off\" }\r\n      ]\r\n    }\r\n  ]"
    
    private var mapStyle: GMSMapStyle? = nil
    
//    internal weak var delegate: ExternalApplicationRequestDelegate?
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        mapStyle = try? GMSMapStyle(jsonString: mapStyleJSON)
        
        mapViewArea.layer.borderWidth = 1
        mapViewArea.layer.borderColor = App.style.textAreaBorderColor.cgColor
        mapViewArea.layer.cornerRadius = App.style.textAreaCornerRadius
        
        let mapActionLabel = UILabel()
        mapActionLabel.style(TextStyle.instructions)
        mapActionLabel.text = "Click to Explore & Identify\nSee help for More"
        mapActionLabel.numberOfLines = 2
        mapActionLabel.textAlignment = .center
        mapActionLabel.alpha = 0.85
        
        mapViewArea.addSubview(mapActionLabel)
        mapViewArea.constrainSubviewToBounds(mapActionLabel,
                                             onEdges: [.left, .right, .bottom],
                                             withInset: UIEdgeInsets(top: 0,
                                                                     left: App.style.interiorMargin,
                                                                     bottom: App.style.interiorMargin,
                                                                     right: App.style.interiorMargin))
        
        addMapToView(frame: CGRect(origin: .zero, size: mapViewArea.frame.size))
        layoutPin()
        
        self.contentView.addSubview(mapViewArea)
        self.contentView.constrainSubviewToBounds(mapViewArea, withInset: UIEdgeInsets(App.style.interiorMargin))
        
        mapViewArea.addConstraint(.init(item: mapViewArea, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        mapView.settings.consumesGesturesInView = false

        if let style = mapStyle {
            mapView.mapStyle = style
        }
        
        self.mapView = mapView
        self.mapViewArea.addSubview(mapView)
        self.mapViewArea.sendSubviewToBack(mapView)
    }
    
    private func layoutPin() {
        mapView?.clear()
        
        if let coordinate = coordinate?.coreLocationCoordinate {
            let marker = GMSMarker(position: coordinate)
            marker.title = "Enter marker title here"
            marker.map = self.mapView
            
            self.mapView?.camera = GMSCameraPosition(target: coordinate, zoom: mapZoom, bearing: 0, viewingAngle: 0)
        }
    }
}

extension MapCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        guard let coordinate = self.coordinate else {
            return
        }
        
//        delegate?.requestMapApplication(forCoordinate: coordinate)
    }
}
