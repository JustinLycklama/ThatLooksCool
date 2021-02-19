//
//  ShadowView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public enum ShadowType {
    case none
    case border(radius: CGFloat, offset: CGSize)
    case contact(distance: CGFloat)
}

open class ShadowView: UIView {

    public var shadowType = ShadowType.border(radius: 5, offset: .zero) {
        didSet {
            modifyShadow()
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            modifyShadow()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .white
        layer.cornerRadius = TLCStyle.cornerRadius

        modifyShadow()
    }
    
    private func modifyShadow() {
        switch shadowType {
        case .border(let radius, let offset):
            addBorderShadow(radius: radius, offset: offset)
        case .contact(let distance):
            addContactShadow(shadowDistance: distance)
        case .none:
            removeShadow()
        }
    }
    
    private func removeShadow() {
        self.layer.shadowPath = nil
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    private func addBorderShadow(radius: CGFloat = 5, offset: CGSize = .zero) {
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    private func addContactShadow(shadowDistance: CGFloat = 0) {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: self.bounds.size.height - (shadowSize * 0.4) + shadowDistance, width: self.bounds.size.width + shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
    }
}
