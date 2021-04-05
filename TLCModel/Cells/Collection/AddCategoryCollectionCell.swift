//
//  AddCollectionCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-03-21.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import Foundation

import UIKit

public class AddCategoryCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        
//        self.contentView.backgroundColor = .blue
        
        let icon = CategoryIcon()

        icon.image = TLCIconSet.plus.image()?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = TLCStyle.progressIconColor
        
        self.contentView.addSubview(icon)
        self.contentView.constrainSubviewToBounds(icon, onEdges: [.left, .right])
        
        self.addConstraint(.init(item: icon, attribute: .centerY, relatedBy: .equal,
                                 toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
