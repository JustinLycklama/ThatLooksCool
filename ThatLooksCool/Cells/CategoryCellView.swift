//
//  CategoryCellView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class CategoryCellView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
//    let stack = UIStackView()
    
    override var bounds: CGRect {
        didSet {
            addBorderShadow()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .brown
        
//        stack.axis = .vertical
        
        titleLabel.text = "default Text"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        
        self.layer.cornerRadius = TLCStyle.cornerRadius

        self.clipsToBounds = false
        
        
        addBorderShadow()
//        stack.addArrangedSubview(titleLabel)
//
//        self.addSubview(stack)
//        self.constrainSubviewToBounds(stack)
        
//        let height = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
//        height.priority = .defaultHigh
//
//        addConstraint(height)
    }

    func displayCategory(displayable: CategoryDisplayable) {
        titleLabel.text = displayable.title
        backgroundColor = displayable.color
    }
}
