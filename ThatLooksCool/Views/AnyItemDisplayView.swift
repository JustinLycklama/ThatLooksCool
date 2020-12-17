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

class AnyItemDisplayView: UIView {
    
    internal let item: Displayable
        
    private let titleLabel = UILabel()
    
    private let dateLabel = UILabel()

    private let detailLabel = UILabel()
    
    private let mapView: GMSMapView = GMSMapView(frame: .zero)
//    var camera: GMSCameraPosition?
    
    var currentCoordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = currentCoordinate {
                mapView.clear()
                
                let marker = GMSMarker()
                marker.position = coordinate
                marker.map = mapView
                
                mapView.camera = GMSCameraPosition.init(target: coordinate, zoom: 6)
                mapView.animate(toZoom: 16) // TODO: Fun zooms?
            }
        }
    }

    init(item: Displayable) {
        self.item = item
        super.init(frame: .zero)
        setup()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = TLCStyle.interiorPadding
        
        addSubview(stackView)
        constrainSubviewToBounds(stackView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin, left: TLCStyle.interiorMargin, bottom: TLCStyle.interiorMargin, right: TLCStyle.interiorMargin))
        
        // Title
        
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
        
        // Date
        
//        dateLabel.text =
        
        // Map
        
//        mapView = GMSMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(mapView)
          
        let heightConstraint = NSLayoutConstraint.init(item: mapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        mapView.addConstraint(heightConstraint)
    }
    
//    internal func setDisplayableItem(item: Displayable) {
//
//
////        titleLabel.text = item?.title
////        currentCoordinate = item?.coordinate?.coreLocationCoordinate
//    }

}
