//
//  ItemCellView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-05.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class ItemCellView: ShadowView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.style(.userText)
        detailLabel.style(.userText)
        
        self.clipsToBounds = false
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        self.layer.borderWidth = 1
        self.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        titleLabel.text = "default Text"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
    }

    func displayItem(displayable: ItemDisplayable) {
        titleLabel.text = displayable.title
        detailLabel.text = displayable.info
    }
}
