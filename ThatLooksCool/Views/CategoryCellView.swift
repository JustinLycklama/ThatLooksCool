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

    private let titleLabel = UILabel()
    
    let stack = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

//    override var intrinsicContentSize: CGSize {
//        get {
//            return stack.intrinsicContentSize
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .brown
        
        stack.axis = .vertical
        
        titleLabel.text = "default Text"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        stack.addArrangedSubview(titleLabel)
        
        self.addSubview(stack)
        self.constrainSubviewToBounds(stack)
        
        let height = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        height.priority = .defaultHigh
        
        addConstraint(height)
    }

    func displayCategory(displayable: CategoryDisplayable) {
        titleLabel.text = displayable.title
        backgroundColor = displayable.color
    }
}
