//
//  CategoryIcon.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public class CategoryIcon: UIView {

    public var image: UIImage? = nil {
        didSet {
            iconImageView.image = image
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = image
        
        return imageView
    }()
    
    public init() {
        super.init(frame: .zero)

        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.addSubview(iconImageView)
        self.constrainSubviewToBounds(iconImageView, withInset: UIEdgeInsets(TLCStyle.elementMargin))
        
        self.addConstraint(.init(item: self, attribute: .height, relatedBy: .equal,
                                 toItem: self, attribute: .width, multiplier: 1, constant: 0))
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
