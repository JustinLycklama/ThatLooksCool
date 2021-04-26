//
//  HeaderContentView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-25.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class HeaderContentLayout: UIView {

    init(header: UIView, content: UIView, spacing: CGFloat = 0, headerHeight: CGFloat? = nil) {
        super.init(frame: .zero)
        
        self.addSubview(header)
        self.constrainSubviewToBounds(header, onEdges: [.top, .left, .right])
        
        self.addSubview(content)
        self.constrainSubviewToBounds(content, onEdges: [.left, .right, .bottom])
        
        self.addConstraint(.init(item: header, attribute: .bottom, relatedBy: .equal, toItem: content, attribute: .top, multiplier: 1, constant: -spacing))
        
        if let headerHeight = headerHeight {
            self.addConstraint(.init(item: header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: headerHeight))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
