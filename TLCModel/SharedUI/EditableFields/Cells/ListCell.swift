//
//  ListCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-22.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    let titleLabel = UILabel()
    let itemsLabel = UILabel()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title + ":"
            titleLabel.sizeToFit()
//            layoutIfNeeded()
        }
    }
    
    var items: [String] = [] {
        didSet {
            var itemsString = items.reduce("") { (soFar, item) -> String in
                return soFar + "\u{2022} \(item)\n"
            }
            
            itemsString.removeLast()
            itemsLabel.text = itemsString
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.numberOfLines = 0
        
        selectionStyle = .none
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = TLCStyle.interiorPadding
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        itemsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        titleContainer.constrainSubviewToBounds(titleLabel, onEdges: [.top, .left, .right])
        
        stack.addArrangedSubview(titleContainer)
        stack.addArrangedSubview(itemsLabel)
        
        let stackContainer = UIView()
        
        stackContainer.layer.cornerRadius = TLCStyle.textCornerRadius
        stackContainer.layer.borderWidth = 1
        stackContainer.layer.borderColor = TLCStyle.textBorderColor.cgColor
        
        stackContainer.addSubview(stack)
        stackContainer.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(TLCStyle.interiorMargin))
        
        self.addSubview(stackContainer)
        self.constrainSubviewToBounds(stackContainer, withInset: UIEdgeInsets(TLCStyle.interiorMargin))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
