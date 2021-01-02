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
    
    // MARK: - Metrics
    
    public static let topLevelMargin: CGFloat = 32
    public static  let topLevelPadding: CGFloat = 16
    
    public static let interiorMargin: CGFloat = 8
    public static let interiorPadding: CGFloat = 8
    
    public static let cornerRadius: CGFloat = 10
    public static let textCornerRadius: CGFloat = 5
    
    // MARK: - Colors
    
    fileprivate struct ColorPallet {
        static let lightGrey = UIColor(rgb: 0xEFF0F3)
        static let mediumGrey = UIColor(rgb: 0x9fa7bb)
        static let darkGrey = UIColor(rgb: 0x424B54)


        static let darkBlue = UIColor(rgb: 0x344180)
        static let red = UIColor(rgb: 0xbb5a68)
        static let yellow = UIColor(rgb: 0xedca45)
        
        
        // 1
        static let turquoise = UIColor(rgb: 0x34D1BF)
        static let lightCyan = UIColor(rgb: 0xE5FCF5)
        
        // 2
        static let mediumBlue = UIColor(rgb: 0x048BA8)
        static let pink = UIColor(rgb: 0xEEC8E0)
    }
        
    
    public static let accentColor = ColorPallet.yellow
    public static let shadowColor = ColorPallet.mediumGrey
    
    public static let textBorderColor = ColorPallet.mediumGrey
    public static let darkBorderColor = ColorPallet.darkGrey
    
    public static let primaryBackgroundColor = ColorPallet.lightGrey
//    public static let secondaryBackgroundColor = ColorPallet.mediumGrey

    public static let primaryIconColor = ColorPallet.turquoise
    public static let destructiveIconColor = ColorPallet.red
}

extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}

extension UIView {
    func removeShadow() {
        self.layer.shadowPath = nil
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    func addBorderShadow(radius: CGFloat = 5, offset: CGSize = .zero) {
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    func addContactShadow(shadowDistance: CGFloat = 0) {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: self.bounds.size.height - (shadowSize * 0.4) + shadowDistance, width: self.bounds.size.width + shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
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
            return TLCStyle.ColorPallet.darkGrey
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
