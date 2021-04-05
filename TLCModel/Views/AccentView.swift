//
//  AccentView.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-03-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

import ClassicClient

public class AccentView: UIView {
    
    private lazy var primaryArea: UIView = {
        let shadowView = ShadowView()
        shadowView.backgroundColor = TLCStyle.itemBackgroundColor
        shadowView.layer.cornerRadius = TLCStyle.cornerRadius
        
        return shadowView
    }()
    
    private let secondaryArea: UIView = UIView()
    
    public init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.layer.cornerRadius = TLCStyle.cornerRadius

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.spacing = TLCStyle.elementPadding
    
        hStack.addArrangedSubview(primaryArea)
        hStack.addArrangedSubview(secondaryArea)
                
        self.addSubview(hStack)
        self.constrainSubviewToBounds(hStack)
        
        self.addConstraint(.init(item: primaryArea, attribute: .width, relatedBy: .equal, toItem: secondaryArea, attribute: .width, multiplier: 1.333, constant: 0))
    }
    
    public func setPrimaryView(_ view: UIView) {
        primaryArea.addSubview(view)
        primaryArea.constrainSubviewToBounds(view, onEdges: [.top, .left, .bottom], withInset: UIEdgeInsets(TLCStyle.elementMargin))
        primaryArea.constrainSubviewToBounds(view, onEdges: [.right], withInset: UIEdgeInsets(TLCStyle.elementPadding))
    }
    
    public func setSecondaryView(_ view: UIView) {
        secondaryArea.addSubview(view)
        secondaryArea.constrainSubviewToBounds(view, onEdges: [.right], withInset: UIEdgeInsets(TLCStyle.elementMargin))
        secondaryArea.constrainSubviewToBounds(view, onEdges: [.top], withInset: UIEdgeInsets(TLCStyle.elementMargin + 2))
        secondaryArea.constrainSubviewToBounds(view, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.elementMargin - 2))
        secondaryArea.constrainSubviewToBounds(view, onEdges: [.left], withInset: UIEdgeInsets(TLCStyle.elementPadding))
    }
}
