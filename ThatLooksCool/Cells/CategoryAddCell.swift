//
//  CategoryAddCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class CategoryAddCell: UITableViewCell {

    private var shadowView = ShadowView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        selectionStyle = .none
                
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = TLCStyle.primaryIconColor
        
        shadowView.addSubview(imageView)
        shadowView.constrainSubviewToBounds(imageView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                               left: TLCStyle.interiorMargin,
                                                                               bottom: TLCStyle.interiorMargin,
                                                                               right: TLCStyle.interiorMargin))
        
        imageView.contentMode = .scaleAspectFit
        imageView.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
        
        self.contentView.addSubview(shadowView)
        self.contentView.constrainSubviewToBounds(shadowView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                                      left: 0,
                                                                                      bottom: TLCStyle.interiorMargin,
                                                                                      right: 0))
    }
}
