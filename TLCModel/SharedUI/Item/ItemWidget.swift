//
//  ItemWidget.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class ItemWidget: UIView {
    private lazy var mapView: UIView =  {
        let view = UIView()
        
//        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24))
//        view.addConstraint(.init(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 3, constant: 0))

        view.backgroundColor = .blue
        
        return view
    }()
    
    private lazy var categoryIcon: UIView = {
        
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.heading.size, weight: .light, scale: .default)
        let image = UIImage(systemName: "books.vertical", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal).withTintColor(TLCStyle.accentColor)
        
//        let view = CategoryIcon(image: image)
        let view = UIImageView()
        view.image = image
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = TLCStyle.itemBackgroundColor
        
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        
        
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        

        let titleLable = UILabel()
        
        titleLable.text = "Yolo"
        titleLable.textColor = .white
        
    
        vStack.addArrangedSubview(titleLable)
        vStack.addConstraint(.init(item: vStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))
        
        
        
        hStack.addArrangedSubview(vStack)

        
        hStack.addArrangedSubview(categoryIcon)
        
        self.addSubview(hStack)
        self.constrainSubviewToBounds(hStack, withInset: UIEdgeInsets(TLCStyle.elementMargin))
    }
}
