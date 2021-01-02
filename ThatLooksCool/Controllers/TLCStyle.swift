//
//  TLCStyle.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public struct TLCStyle {
    
    fileprivate struct ColorPallet {
        static let lightGrey = UIColor(rgb: 0xEFF0F3)
        static let darkBlue = UIColor(rgb: 0x344180)
        static let darkGrey = UIColor(rgb: 0x9fa7bb)
        static let red = UIColor(rgb: 0xbb5a68)
        static let yellow = UIColor(rgb: 0xedca45)
    }
        
    
    public static let topLevelMargin: CGFloat = 32
    public static  let topLevelPadding: CGFloat = 16
    
    public static let interiorMargin: CGFloat = 8
    public static let interiorPadding: CGFloat = 8

    public static let cornerRadius: CGFloat = 10
    
    public static let primaryBackgroundColor = ColorPallet.lightGrey
    public static let shadowColor = ColorPallet.darkGrey
    public static let primaryIconColor = ColorPallet.yellow

    
    
    
}

extension UIView {
    func addBorderShadow() {
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    func addContactShadow(shadowDistance: CGFloat = 0) {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: self.bounds.size.height - (shadowSize * 0.4) + shadowDistance, width: self.bounds.size.width + shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.4
    }
}

enum LabelType {
    case heading
    
    var fontName: String {
        switch self {
        case .heading:
            return "Avenir-Book"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .heading:
            return TLCStyle.ColorPallet.red
        }
    }
    
    var size: CGFloat {
        switch self {
        case .heading:
            return 24
        }
    }
}

extension UILabel {
    func style(_ type: LabelType) {
        self.font = UIFont(name: type.fontName, size: type.size)
        self.textColor = type.textColor
    }
}
