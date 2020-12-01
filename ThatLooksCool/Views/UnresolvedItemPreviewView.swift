//
//  UnresolvedItemPreviewView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

import GoogleMaps

class UnresolvedItemPreviewView: UIView {

    let stackView = UIStackView()
    
    let title = UILabel()
    
    var mapView: GMSMapView?
    var camera: GMSCameraPosition?
    
    var currentCoordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = currentCoordinate {
                mapView?.clear()
                
                let marker = GMSMarker()
                marker.position = coordinate
                marker.map = mapView
                
                mapView?.camera = GMSCameraPosition.init(target: coordinate, zoom: 6)
                mapView?.animate(toZoom: 16) // TODO: Fun zooms?
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        stackView.axis = .vertical
        stackView.spacing = TLCStyle.interiorPadding
        
        addSubview(stackView)
        constrainSubviewToBounds(stackView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin, left: TLCStyle.interiorMargin, bottom: TLCStyle.interiorMargin, right: TLCStyle.interiorMargin))
        
        // Title
        
        title.text = "Any Title"
        stackView.addArrangedSubview(title)
        
        // Map
        
        mapView = GMSMapView(frame: .zero)
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(mapView!)
          
        let heightConstraint = NSLayoutConstraint.init(item: mapView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        mapView?.addConstraint(heightConstraint)
    }
    
    // TODO: Any unresolved Item
    public func setItem(item: UnresolvedLocation?) {
        title.text = String(item?.timestamp?.timeIntervalSinceNow ?? 0.0)
        currentCoordinate = item?.coordinate?.coreLocationCoordinate
    }
}
