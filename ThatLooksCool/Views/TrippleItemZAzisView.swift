//
//  TrippleItemZAzisView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class TrippleItemZAzisView: UIView {
    
    public let itemDisplayArea = ShadowView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let borderWidth: CGFloat = 0
        
        let itemMargin = TLCStyle.interiorMargin
        let itemSeperation = TLCStyle.topLevelPadding
        
//        let itemsMargin = itemSeperation * 3
        
        // Real Item Display
        
        itemDisplayArea.backgroundColor = .white
        itemDisplayArea.layer.cornerRadius = TLCStyle.cornerRadius
        itemDisplayArea.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        itemDisplayArea.layer.borderColor = TLCStyle.darkBorderColor.cgColor
        itemDisplayArea.layer.borderWidth = 1
        
        self.addSubview(itemDisplayArea)
        self.constrainSubviewToBounds(itemDisplayArea,
                                      withInset: UIEdgeInsets(top: itemMargin,
                                                              left: itemMargin,
                                                              bottom: borderWidth,
                                                              right: itemMargin + (itemSeperation * 2)))
        
        itemDisplayArea.addConstraint(NSLayoutConstraint.init(item: itemDisplayArea, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        // Fake Item Displays
        
        let fakeItem1 = UIView()
        fakeItem1.backgroundColor = .white
        fakeItem1.layer.cornerRadius = TLCStyle.cornerRadius
        fakeItem1.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        fakeItem1.layer.borderColor = TLCStyle.darkBorderColor.cgColor
        fakeItem1.layer.borderWidth = 1
        
        self.addSubview(fakeItem1)
        self.constrainSubviewToBounds(fakeItem1,
                                                 withInset: UIEdgeInsets(top: itemMargin - itemSeperation,
                                                                         left: itemMargin + itemSeperation,
                                                                         bottom: borderWidth,
                                                                         right: itemMargin + itemSeperation))
        
        self.sendSubviewToBack(fakeItem1)
        
        let fakeItem2 = UIView()
        fakeItem2.backgroundColor = .white
        fakeItem2.layer.cornerRadius = TLCStyle.cornerRadius
        fakeItem2.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        fakeItem2.layer.borderColor = TLCStyle.darkBorderColor.cgColor
        fakeItem2.layer.borderWidth = 1
        
        self.addSubview(fakeItem2)
        self.constrainSubviewToBounds(fakeItem2,
                                                 withInset: UIEdgeInsets(top: itemMargin - (itemSeperation * 2),
                                                                         left: itemMargin + (itemSeperation * 2),
                                                                         bottom: borderWidth,
                                                                         right: itemMargin))
        
        self.sendSubviewToBack(fakeItem2)
    }
}
