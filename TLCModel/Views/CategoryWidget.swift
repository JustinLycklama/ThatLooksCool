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

    lazy var icon: CategoryIcon = {
        let view = CategoryIcon()
        
//        view.addConstraint(.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48))
        
        return view
    }()
    
    public internal(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.style(TextStyle.categoryWidgetStyle)
//        widget.styleTitle(TextStyle.accentLabel)
        
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
        stack.distribution = .equalSpacing
        stack.spacing = TLCStyle.elementPadding
        
        let iconContainer = UIView()
        iconContainer.addSubview(icon)
        iconContainer.constrainSubviewToBounds(icon, onEdges: [.top, .bottom])
        iconContainer.addConstraint(.init(item: icon, attribute: .centerX, relatedBy: .equal, toItem: iconContainer, attribute: .centerX, multiplier: 1, constant: 0))
        
        stack.addArrangedSubview(iconContainer)
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        titleContainer.constrainSubviewToBounds(titleLabel, onEdges: [.top, .left, .right])
        
        
        stack.addArrangedSubview(titleContainer)
//        stack.addArrangedSubview(UIView())
        
        addSubview(stack)
        constrainSubviewToBounds(stack, onEdges: [.top, .left, .right, .bottom])
        
        self.addConstraint(.init(item: titleContainer, attribute: .height, relatedBy: .equal, toItem: iconContainer, attribute: .height, multiplier: 0.666, constant: 0))

        
//        self.addConstraint(.init(item: icon, attribute: .height, relatedBy: .lessThanOrEqual,
//                                 toItem: titleContainer, attribute: .height, multiplier: 1, constant: 0))
        
//        icon.backgroundColor = .blue
    }
        
    public func displayCategory(displayable: CategoryDisplayable) {
        titleLabel.text = displayable.title
        icon.image = displayable.icon.image()
    }
}
