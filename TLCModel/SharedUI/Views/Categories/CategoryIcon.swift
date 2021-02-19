//
//  CategoryIcon.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class CategoryIcon: UIView {
    
    let image: UIImage?
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
    
        let imageConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.heading.size, weight: .light, scale: .default)
        imageView.image = UIImage(systemName: "books.vertical", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
        
        return imageView
    }()
    
    init(image: UIImage?) {
        self.image = image
        
        super.init(frame: .zero)

        // assuming image is 30x30
        self.layer.cornerRadius = (30 + Classic.style.collectionMargin * 2)/2
        self.addConstraint(.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.addSubview(iconImage)
        self.constrainSubviewToBounds(iconImage, withInset: UIEdgeInsets(Classic.style.collectionMargin))
        
//        area.layoutIfNeeded()
//
//        let radius: CGFloat = area.bounds.size.width / 2.0
//        area.layer.cornerRadius = radius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
