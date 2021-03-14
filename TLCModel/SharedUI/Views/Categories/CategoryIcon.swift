//
//  CategoryIcon.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public class CategoryIcon: UIView {
        
    var image: UIImage? {
        didSet {
            iconImage.image = image
        }
    }
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.addConstraint(.init(item: imageView, attribute: .height, relatedBy: .equal,
                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TLCStyle.categoryImageHeight))
        
        imageView.image = image
        
        return imageView
    }()
    
    public convenience init(category: ItemCategory?, borderColor: UIColor = .white) {
        self.init(image: nil, borderColor: borderColor)
        
        defer {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.heading.size, weight: .light, scale: .default)
            image = UIImage(systemName: "books.vertical", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    public init(image: UIImage?, borderColor: UIColor = .white) {
        self.image = image
        
        super.init(frame: .zero)

        // assuming image is 30x30
        self.layer.cornerRadius = (30 + Classic.style.collectionMargin * 2)/2
        self.addConstraint(.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
        
        self.backgroundColor = borderColor
        self.clipsToBounds = true
        
        self.addSubview(iconImage)
        self.constrainSubviewToBounds(iconImage, withInset: UIEdgeInsets(TLCStyle.elementMargin))
        
//        area.layoutIfNeeded()
//
//        let radius: CGFloat = area.bounds.size.width / 2.0
//        area.layer.cornerRadius = radius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImage(_ image: UIImage?) {
        self.image = image
    }
}
