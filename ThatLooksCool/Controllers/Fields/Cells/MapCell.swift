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

    @IBOutlet var mapView: GMSMapView!
    
    var coordinate: Coordinate? {
        didSet {
            mapView.clear()
            
            if let coordinate = coordinate?.coreLocationCoordinate {
                let marker = GMSMarker()
                marker.position = coordinate
                marker.map = mapView
                
                mapView.camera = GMSCameraPosition.init(target: coordinate, zoom: 6)
                mapView.animate(toZoom: 16) // TODO: Fun zooms?
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        mapView.isUserInteractionEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
