//
//  TLCStyle.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient


public enum TLCIconSet: String, CaseIterable, Icon {
    public var id: String {
        "\(namespace).\(rawValue)"
    }
    
    public static func register() {
        let appResources = Classic.resources
        for icon in TLCIconSet.allCases {
            icon.registerImage(to: appResources)
        }
    }
    
    case edit = "edit"
    case delete = "delete"
    case undo = "undo"
    case next = "next"
    case list = "list"
    
    var size: CGSize {
        CGSize(width: 30, height: 30)
    }
    
    private func create() -> UIImage? {
        return UIImage(named: rawValue)
    }

    private func registerImage(to appResources: AppResources) {
        switch self {
        case .edit:
            appResources.register(appResources.render(create(), withColor: TLCStyle.modificationIconColor, andSize: size), for: self)
        case .delete:
            appResources.register(appResources.render(create(), withColor: TLCStyle.destructiveIconColor, andSize: size), for: self)
        case .undo:
            appResources.register(appResources.render(create(), withColor: TLCStyle.modificationIconColor, andSize: size), for: self)
        case .next:
            appResources.register(appResources.render(create(), withColor: TLCStyle.progressIconColor, andSize: size), for: self)
        case .list:
            appResources.register(appResources.render(create(), withColor: TLCStyle.accentColor, andSize: size), for: self)
        }
    }
    
    public func image() -> UIImage? {
        Classic.resources.getImage(from: self)
    }
}

public struct NewStyle {
    public static let shared = NewStyle()
    private static var bundle = Bundle(for: RealmSubjects.self)
    
    private init() {}
}

extension NewStyle: MetricsStyle {
    public var topMargin: CGFloat {
        24
    }
    
    public var topPadding: CGFloat {
        16
    }
    
    public var interiorMargin: CGFloat {
        13
    }
    
    public var interiorPadding: CGFloat {
        8
    }
    
    public var cornerRadius: CGFloat {
        10
    }
    
    public var formPadding: CGFloat {
        8
    }
    
    public var formMargin: CGFloat {
        10
    }
    
    public var textAreaCornerRadius: CGFloat {
        10
    }
    
    
}

extension NewStyle: ColorStyle {
    public var primaryColor: UIColor {
        ColorAssets.accent1.color
    }

    public var secondaryColor: UIColor {
        ColorAssets.accent2.color
    }

    public var baseBackgroundColor: UIColor {
        ColorAssets.whitebase1.color
    }

    public var acceptButtonBackgroundColor: UIColor {
        ColorAssets.accent4.color
    }

    public var accentButtonBackgroundColor: UIColor {
        ColorAssets.accent5.color
    }

    public var textAreaBorderColor: UIColor {
        ColorAssets.base2.color
    }

    public var titleTextColor: UIColor {
        ColorAssets.whitebase0.color
    }
    
    public var titleTextAccentColor: UIColor {
        ColorAssets.accent3.color
    }
    
    private enum ColorAssets: String {
        case base6 = "Base6"
        case base5 = "Base5"
        case base4 = "Base4"
        case base3 = "Base3"
        case base2 = "Base2"
        case base1 = "Base1"
        case whitebase0 = "WhiteBase0"
        case whitebase1 = "WhiteBase1"
        case whitebase2 = "WhiteBase2"
        case accent1 = "Accent1"
        case accent2 = "Accent2"
        case accent3 = "Accent3"
        case accent4 = "Accent4"
        case accent5 = "Accent5"
        case accent6 = "Accent6"
        case accent7 = "Accent7"
        case accent8 = "Accent8"

        var color: UIColor {
            UIColor.init(named: rawValue, in: bundle, compatibleWith: nil) ?? UIColor.systemPink
        }
    }
}



extension NewStyle: FontStyle {
    public var placeholderTextAttributes: [NSAttributedString.Key : Any] {
        attributesForStyle(TextStyle.label)
    }
    
    
    func attributesForStyle(_ style: TextStylable) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font : UIFont.fromStyle(style: style),
                NSAttributedString.Key.foregroundColor : style.textColor]
    }
    
}


public struct TLCStyle {
    
    // MARK: - Metrics
    
    public static let topLevelMargin: CGFloat = 16
    public static  let topLevelPadding: CGFloat = 16
    
    public static let interiorMargin: CGFloat = 12
    public static let interiorPadding: CGFloat = 6
    
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

    
    
    private static var bundle = Bundle(for: RealmSubjects.self)

    // New
    public static let headingViewColor = UIColor(named: "Base6", in: bundle, compatibleWith: nil)
    public static let titleTextColor = UIColor(named: "WhiteBase1", in: bundle, compatibleWith: nil)
    public static let titleTextAccentColor = UIColor(named: "Acent2", in: bundle, compatibleWith: nil)
    
    
    
    
    
    
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
    case subtitle
    
    public var fontName: String {
        switch self {
        case .navBar:
            return "KohinoorTelugu-Medium"
        case .barButton:
            return "AvenirNext-Regular"
        case .heading, .instructions:
            return "AppleSDGothicNeo-Regular"
        case .label:
            return "AppleSDGothicNeo-Light"
        case .userText:
            return "KohinoorTelugu-Regular"
        case .systemInfoLink:
            return "AvenirNextCondensed-Medium"
        case .subtitle:
            return "Thonburi-Light"
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
        case .subtitle:
            return TLCStyle.ColorPallet.black
        }
    }
    
    public var size: CGFloat {
        switch self {
        case .navBar:
            return 22
        case .barButton:
            return 16
        case .heading:
            return 32
        case .instructions:
            return 16
        case .label:
            return 16
        case .userText:
            return 20
        case .systemInfoLink:
            return 16
        case .subtitle:
            return 14
        }
    }
}
