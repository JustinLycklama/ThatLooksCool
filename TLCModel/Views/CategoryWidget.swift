//
//  CategoryWidget.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public class CategoryWidget: UIView {

    lazy var icon: UIView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.heading.size, weight: .light, scale: .default)
        let image = UIImage(systemName: "books.vertical", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
        
        let view = CategoryIcon(image: image)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.style(TextStyle.subtitle)
        
        label.text = "123456789012"
        label.numberOfLines = 2 
        label.setContentCompressionResistancePriority(.required, for: .vertical)
                
        return label
    }()
    
    let stack = UIStackView()
    
    public override var intrinsicContentSize: CGSize {
        stack.intrinsicContentSize
    }
    
    public init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear

        stack.axis = .vertical
        stack.spacing = Classic.style.collectionPadding
        
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(titleLabel)
        
        addSubview(stack)
        constrainSubviewToBounds(stack)
        
        addConstraint(.init(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: icon, attribute: .width, multiplier: 1, constant: 0))
        
        invalidateIntrinsicContentSize()
    }
    
    public func displayCategory(displayable: CategoryDisplayable) {
//        titleLabel.text = displayable.title
//        backgroundColor = displayable.color
        
        
    }
    
    public func styleTitle(_ style: TextStylable) {
        titleLabel.style(style)
    }
}
