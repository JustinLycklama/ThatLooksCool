//
//  TrippleItemZAzisView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
//import EasyNotificationBadge

public class TripleItemZAxisView: UIView {
    
    public let itemDisplayArea = UIView()
    
    let badgePositioner = UIView()
//    var badgeAppearance = BadgeAppearance()
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let borderWidth: CGFloat = 0
        
        let itemMargin = TLCStyle.collectionMargin
        let itemSeperation: CGFloat = 12
        
//        let itemsMargin = itemSeperation * 3
        
        // Real Item Display
        
        itemDisplayArea.backgroundColor = .white
        itemDisplayArea.layer.cornerRadius = TLCStyle.cornerRadius
        itemDisplayArea.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        itemDisplayArea.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        itemDisplayArea.layer.borderWidth = 1
        
        self.addSubview(itemDisplayArea)
        self.constrainSubviewToBounds(itemDisplayArea,
                                      withInset: UIEdgeInsets(top: itemMargin,
                                                              left: itemMargin,
                                                              bottom: borderWidth,
                                                              right: itemMargin + (itemSeperation * 2)))
        
        let minimumHeightContraint = NSLayoutConstraint.init(item: itemDisplayArea,
                                                             attribute: .height,
                                                             relatedBy: .greaterThanOrEqual,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1, constant: 44)
        
        minimumHeightContraint.priority = .defaultHigh        
        itemDisplayArea.addConstraint(minimumHeightContraint)
        
        // Fake Item Displays
        
        let fakeItem1 = UIView()
        fakeItem1.backgroundColor = .white
        fakeItem1.layer.cornerRadius = TLCStyle.cornerRadius
        fakeItem1.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        fakeItem1.layer.borderColor = TLCStyle.viewBorderColor.cgColor
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
        fakeItem2.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        fakeItem2.layer.borderWidth = 1
        
        self.addSubview(fakeItem2)
        self.constrainSubviewToBounds(fakeItem2,
                                                 withInset: UIEdgeInsets(top: itemMargin - (itemSeperation * 2),
                                                                         left: itemMargin + (itemSeperation * 2),
                                                                         bottom: borderWidth,
                                                                         right: itemMargin))
        
        self.sendSubviewToBack(fakeItem2)
                
//        badgeAppearance.duration = 2
//        badgeAppearance.borderWidth = 1
//        badgeAppearance.borderColor = NewStyle.viewBorderColor
//        badgeAppearance.allowShadow = true
//        badgeAppearance.font = UIFont(name: "Avenir-Book", size: 18)!
        
        self.addSubview(badgePositioner)
        self.constrainSubviewToBounds(badgePositioner, onEdges: [.right, .top],
                                      withInset: UIEdgeInsets(top: -15,
                                                              left: 0,
                                                              bottom: 0,
                                                              right: 10))
    }
    
    public func setBadge(_ value: Int) {        
//        if (value == 0) {
//            badgePositioner.badge(text: nil)
//        } else {
//            badgePositioner.badge(text: String(value), appearance: badgeAppearance)
//        }
    }
}
