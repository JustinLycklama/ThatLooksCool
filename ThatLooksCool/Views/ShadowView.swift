//
//  ShadowView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

enum ShadowType {
    case none
    case border(radius: CGFloat, offset: CGSize)
    case contact(distance: CGFloat)
}

class ShadowView: UIView {

    var shadowType = ShadowType.border(radius: 5, offset: .zero) {
        didSet {
            modifyShadow()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            modifyShadow()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
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
}
