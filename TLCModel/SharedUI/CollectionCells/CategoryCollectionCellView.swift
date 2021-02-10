//
//  CategoryCollectionCellView.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-09.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class CategoryCollectionCellView: UIView {
        
    lazy var iconArea: UIView = {
        let area = UIView()

//        area.addConstraint(.init(item: area, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
//        area.addConstraint(.init(item: area, attribute: .width, relatedBy: .equal, toItem: area, attribute: .height, multiplier: 1, constant: 0))

        // assuming image is 30x30
        area.layer.cornerRadius = (30 + Classic.style.interiorMargin)/2

        area.backgroundColor = .white
        area.clipsToBounds = true
        
        area.addSubview(iconImage)
        area.constrainSubviewToBounds(iconImage, withInset: UIEdgeInsets(Classic.style.interiorMargin))
        
        return area
    }()
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Classic.resources.getImage(from: TLCIconSet.edit)
        
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.style(TextStyle.subtitle)
        
        label.text = "Test"
        
        return label
    }()
    
    let stack = UIStackView()
    
    override var intrinsicContentSize: CGSize {
        stack.intrinsicContentSize
    }
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear

        stack.axis = .vertical
        stack.spacing = Classic.style.interiorPadding
        
        stack.addArrangedSubview(iconArea)
        stack.addArrangedSubview(titleLabel)
        
        addSubview(stack)
        constrainSubviewToBounds(stack)
        
        invalidateIntrinsicContentSize()
    }
    
    func displayCategory(displayable: CategoryDisplayable) {
//        titleLabel.text = displayable.title
//        backgroundColor = displayable.color
        
        
    }
}
