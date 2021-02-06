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
    
    public static let topLevelMargin: CGFloat = 24
    public static  let topLevelPadding: CGFloat = 16
    
    public static let interiorMargin: CGFloat = 12
    public static let interiorPadding: CGFloat = 8
    
    public static let cornerRadius: CGFloat = 10
    public static let textCornerRadius: CGFloat = 5
    
    // MARK: - Colors
    
    fileprivate struct ColorPallet {
        static let offWhite = UIColor(rgb: 0xFAF9F9)
        static let lightGrey = UIColor(rgb: 0xEFF0F3)
        static let mediumGrey = UIColor(rgb: 0x9fa7bb)
        static let darkGrey = UIColor(rgb: 0x424B54)
        static let black = UIColor.black

        static let darkBlue = UIColor(rgb: 0x344180)
        static let red = UIColor(rgb: 0xbb5a68)
        static let yellow = UIColor(rgb: 0xedca45)
        
        
        // 1
        static let turquoise = UIColor(rgb: 0x34D1BF)
        static let lightCyan = UIColor(rgb: 0xE5FCF5) //#E0BE7C
        
        // 2
        static let mediumBlue = UIColor(rgb: 0x048BA8)
        static let pink = UIColor(rgb: 0xEEC8E0)
    }
        
    
    public static let accentColor = ColorPallet.yellow
    public static let shadowColor = ColorPallet.mediumGrey
    
    public static let textBorderColor = ColorPallet.mediumGrey
    public static let viewBorderColor = ColorPallet.darkGrey
    
    public static let placeholderTextColor = ColorPallet.mediumGrey

    
    public static let primaryBackgroundColor = ColorPallet.lightGrey
    public static let secondaryBackgroundColor = ColorPallet.offWhite

    public static let progressIconColor = ColorPallet.turquoise
    public static let modificationIconColor = ColorPallet.yellow
    public static let destructiveIconColor = ColorPallet.red
    
    public static let placeholderFont = UIFont(name: TextStyle.label.fontName, size: TextStyle.label.size)

    
    // Nav Bar
    public static let navBarBackgroundColor = ColorPallet.lightCyan

    private static let navBarLabelType = TextStyle.navBar
    public static let navBarFont = UIFont(name: navBarLabelType.fontName, size: navBarLabelType.size)
    public static let navBarTextColor = navBarLabelType.textColor
    
    // Bar Button Item
    private static let barButtonLabelType = TextStyle.barButton
    public static let barButtonFont = UIFont(name: barButtonLabelType.fontName, size: barButtonLabelType.size)
    public static let barButtonTextColor = barButtonLabelType.textColor
}

public class ImagesResources {
    public static let shared = ImagesResources()
    
    public lazy var editIcon = renderIcon("edit", withColor: TLCStyle.modificationIconColor)
    public lazy var deleteIcon = renderIcon("delete", withColor: TLCStyle.destructiveIconColor)
    public lazy var undoIcon = renderIcon("undo", withColor: TLCStyle.modificationIconColor)
    public lazy var nextIcon = renderIcon("next", withColor: TLCStyle.progressIconColor)
    public lazy var listIcon = renderIcon("list", withColor: TLCStyle.accentColor)
    
    private func renderIcon(_ name: String, withColor color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            UIImage(named: name)?.withRenderingMode(.alwaysTemplate).draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
    }
}

extension UIView {
    public func removeShadow() {
        self.layer.shadowPath = nil
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    public func addBorderShadow(radius: CGFloat = 5, offset: CGSize = .zero) {
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = TLCStyle.shadowColor.cgColor
    }
    
    public func addContactShadow(shadowDistance: CGFloat = 0) {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: self.bounds.size.height - (shadowSize * 0.4) + shadowDistance, width: self.bounds.size.width + shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
    }
}

extension UIViewController {
    public func addBackgroundImage() {
//        let backgroundImage = UIImageView()
//        backgroundImage.image = UIImage(named: "city-side-bg")
//        backgroundImage.contentMode = .scaleAspectFill
//
//        self.view.addSubview(backgroundImage)
//        self.view.constrainSubviewToBounds(backgroundImage)
//
//        self.view.sendSubviewToBack(backgroundImage)
    }
}


public enum TextStyle: TextStylable {
    case navBar
    case barButton
    case heading
    case instructions
    case label
    case userText
    case systemInfoLink
    
    public var fontName: String {
        switch self {
        case .navBar:
            return "KohinoorTelugu-Medium"
        case .barButton:
            return "AvenirNext-Regular"
        case .heading, .instructions:
            return "Noteworthy-Bold"
        case .label:
            return "AvenirNext-Regular"
        case .userText:
            return "KohinoorTelugu-Regular"
        case .systemInfoLink:
            return "AvenirNextCondensed-Medium"
        }
    }
    
    public var textColor: UIColor {
        
        switch self {
        case .navBar, .barButton:
            return TLCStyle.ColorPallet.darkGrey
        case .heading, .instructions:
            return TLCStyle.ColorPallet.darkGrey
        case .label:
            return TLCStyle.ColorPallet.darkGrey
        case .userText:
            return TLCStyle.ColorPallet.black
        case .systemInfoLink:
            return TLCStyle.ColorPallet.turquoise
        }
    }
    
    public var size: CGFloat {
        switch self {
        case .navBar:
            return 22
        case .barButton:
            return 16
        case .heading:
            return 24
        case .instructions:
            return 16
        case .label:
            return 16
        case .userText:
            return 20
        case .systemInfoLink:
            return 16
        }
    }
}
