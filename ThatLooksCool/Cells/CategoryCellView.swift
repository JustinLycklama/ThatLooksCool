//
//  CategoryCellView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class CategoryCellView: ShadowView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.clipsToBounds = false
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        self.layer.borderWidth = 1
        self.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        titleLabel.text = "default Text"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
    }

    func displayCategory(displayable: CategoryDisplayable) {
        titleLabel.text = displayable.title
        backgroundColor = displayable.color
    }
}
