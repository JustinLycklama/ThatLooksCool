//
//  AddCollectionCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-03-21.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import Foundation

import UIKit

public class AddCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        
        let addView = AddView()
        
        self.contentView.addSubview(addView)
        self.contentView.constrainSubviewToBounds(addView)
    }
}
