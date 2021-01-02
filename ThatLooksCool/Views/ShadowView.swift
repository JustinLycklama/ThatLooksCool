//
//  ShadowView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override var bounds: CGRect {
        didSet {
            addBorderShadow()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = TLCStyle.cornerRadius

        addBorderShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
