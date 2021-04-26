//
//  Button.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-04.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class Button: UIButton {
    
    var action: ((Button) -> Void)?
    var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.contentEdgeInsets = TLCStyle.topButtonInsets
        self.backgroundColor = TLCStyle.destructiveIconColor
        self.layer.cornerRadius = TLCStyle.cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        self.addTarget(self, action: #selector(takeAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
        self.backgroundColor = TLCStyle.darkBackgroundTextColor.withAlphaComponent(0.75)
    }
    
    @objc
    func takeAction() {
        action?(self)
    }
}

