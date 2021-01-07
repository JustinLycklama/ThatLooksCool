//
//  CategoryAddCellView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-03.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class AddCellView: UIView {

    private var shadowView = ShadowView()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        shadowView.layer.borderWidth = 1
        shadowView.layer.borderColor = TLCStyle.viewBorderColor.cgColor
                
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = TLCStyle.progressIconColor
        
        shadowView.addSubview(imageView)
        shadowView.constrainSubviewToBounds(imageView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                               left: TLCStyle.interiorMargin,
                                                                               bottom: TLCStyle.interiorMargin,
                                                                               right: TLCStyle.interiorMargin))
        
        imageView.contentMode = .scaleAspectFit
        
        let width = NSLayoutConstraint.init(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        width.priority = .defaultHigh

        imageView.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
        imageView.addConstraint(width)

        self.addSubview(shadowView)
        self.constrainSubviewToBounds(shadowView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
