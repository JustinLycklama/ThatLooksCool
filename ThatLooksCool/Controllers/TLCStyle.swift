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
        static let offWhite = UIColor(rgb: 0xFAF9F9)
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
    public static let viewBorderColor = ColorPallet.darkGrey
    
    public static let primaryBackgroundColor = ColorPallet.lightGrey
    public static let secondaryBackgroundColor = ColorPallet.offWhite

    public static let progressIconColor = ColorPallet.turquoise
    public static let modificationIconColor = ColorPallet.yellow
    public static let destructiveIconColor = ColorPallet.red
}

class ImagesResources {
    static let shared = ImagesResources()
    
    lazy var editIcon = renderIcon("edit", withColor: TLCStyle.modificationIconColor)
    lazy var deleteIcon = renderIcon("delete", withColor: TLCStyle.destructiveIconColor)
    lazy var undoIcon = renderIcon("undo", withColor: TLCStyle.modificationIconColor)
    lazy var nextIcon = renderIcon("next", withColor: TLCStyle.progressIconColor)

    private func renderIcon(_ name: String, withColor color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            UIImage(named: name)?.withRenderingMode(.alwaysTemplate).draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
    }
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
