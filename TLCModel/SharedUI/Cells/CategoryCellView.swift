//
//  CategoryCellView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

@IBDesignable
public class CategoryCellView: ShadowView {

//    @IBOutlet weak var titleLabel: UILabel!
    
    let titleLabel = UILabel()
    
    @IBInspectable var test: CGFloat {
        get {
            4
        }
    }
    
    public override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.clipsToBounds = false
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        self.layer.borderWidth = 1
        self.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        titleLabel.text = "default Text"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.style(.userText)
        
        addSubview(titleLabel)
        constrainSubviewToBounds(titleLabel, withInset: UIEdgeInsets(TLCStyle.topLevelMargin))
    }

    func displayCategory(displayable: CategoryDisplayable) {
        titleLabel.text = displayable.title
        backgroundColor = displayable.color
    }
}
