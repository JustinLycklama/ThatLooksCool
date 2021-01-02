//
//  TitleContentView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class TitleContentView: UIView {
        
    public let titleLabel = UILabel()
    private let titleStackView = UIStackView()
    
    public let contentView = UIView()
        
    public var leftTitleItem: UIView? {
        didSet {
            arrangeTitleStack()
        }
    }
    
    public var rightTitleItem: UIView? {
        didSet {
            arrangeTitleStack()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            addContactShadow()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    private func initialize() {
        
        backgroundColor = .white
        
        // Title Views
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleStackView.addConstraint(NSLayoutConstraint.init(item: titleStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
        
        // Content Area
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentView.backgroundColor = .clear
        
        // View Layout
        addSubview(titleStackView)
        addSubview(contentView)
        
        let views = ["title" : titleStackView, "content": contentView]
        let metrics = ["spacing" : 12]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[title]-(spacing)-[content]-(0)-|", options: .alignAllCenterX, metrics: metrics, views: views))
        
        constrainSubviewToBounds(titleStackView, onEdges: [.left, .right])
        constrainSubviewToBounds(contentView, onEdges: [.left, .right])
        
        arrangeTitleStack()
    }
    
    private func arrangeTitleStack() {
        
        titleStackView.removeAllArrangedSubviews()
        
        let leftItem = leftTitleItem ?? UIView()
        titleStackView.addArrangedSubview(leftItem)
        
        titleStackView.addArrangedSubview(titleLabel)
                
        let rightItem = rightTitleItem ?? UIView()
        titleStackView.addArrangedSubview(rightItem)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
