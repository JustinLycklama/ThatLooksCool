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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        let mapView = MapView()
        
        self.contentView.addSubview(mapView)
        self.contentView.constrainSubviewToBounds(mapView, withInset: UIEdgeInsets(Classic.style.collectionMargin))
        
        mapView.addConstraint(.init(item: mapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
