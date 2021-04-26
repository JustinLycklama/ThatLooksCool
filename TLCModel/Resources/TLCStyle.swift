//
//  NewStyle.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public enum TLCCategoryIconSet: String, CaseIterable, Icon {
    public var id: String {
        "\(namespace).\(rawValue)"
    }
    
    public static func register() {
        let appResources = Classic.resources
        for icon in TLCCategoryIconSet.allCases {
            appResources.register(icon.create(), for: icon)
        }
    }
    
    public static let defaultIcon: TLCCategoryIconSet = TLCCategoryIconSet.books
    
    case books = "books.vertical"
    case pencil = "pencil"
    case cap = "graduationcap"
    case ticket = "ticket"
    case tag = "tag"
    case camera = "camera"
    case piano = "pianokays"
    case brush = "paintbrush.pointed"
    case ruler = "ruler"
    case scroll = "scroll"
    case briefcase = "briefcase"
    case puzzle = "puzzlepiece"
    case map = "map"
    case controller = "gamecontroller"
    case pallete = "paintpalette"
    case gift = "gift"
    case light = "lightbulb"
    case walk = "figure.walk"
    case bike = "bicycle"
    case leaf = "leaf"
    case cart = "cart"
    case heart = "heart"
    case sign = "signpost.left"
    case people = "person.3"
    case bag = "bag"
    case tv = "tv"
    case music = "tv.music.note"
    case speaker = "hifispeaker"
    case envelope = "envelope"
    
    private func create() -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
        return UIImage(systemName: rawValue, withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
    }
    
    public func image() -> UIImage? {
        Classic.resources.getImage(from: self)
    }
}

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
    case settings = "gearshape"
    case identify = "binoculars.fill"
    case search = "magnifyingglass"
    case plus = "plus.circle"
    case back = "arrowshape.turn.up.backward.fill"
    
    var size: CGSize {
        switch self {
        case .search, .plus:
            return CGSize(width: 24, height: 24)  // Not used
        case .settings, .identify:
            return CGSize(width: 28, height: 28) // Not used
        default:
            return CGSize(width: 32, height: 32)
        }
    }
    
    private func create() -> UIImage? {
        switch self  {
        case .edit, .delete, .undo, .next, .list:
            return UIImage(named: rawValue)
        default:
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
            return UIImage(systemName: rawValue, withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal)
        }
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
        default:
            appResources.register(create()?.withTintColor(.white), for: self)
        }
    }
    
    public func image() -> UIImage? {
        Classic.resources.getImage(from: self)
    }
}

public struct TLCStyle {
    public static let shared = TLCStyle()
    private static var bundle = Bundle(for: RealmSubjects.self)
    
    private init() {}
}

extension TLCStyle: MetricsStyle {
    public var collectionPadding: CGFloat {
        4
    }
    
    
    public static let textInset: CGFloat = 4
    public var textInset: CGFloat {
        TLCStyle.textInset
    }
    
    
    public static let categoryMaxTitleLength = 12
//    public static let categoryImageHeight: CGFloat = 48
    public static let categoryWidgetDesiredSize = CGSize(width: 56, height: 102)
    
    public static var safeArea: UIEdgeInsets {
        get {
            return UIApplication.shared.windows[0].safeAreaInsets
        }
    }
    
    public static let topMargin: CGFloat = 24
    public var topMargin: CGFloat {
        TLCStyle.topMargin
    }
    
    public static let topPadding: CGFloat = 16
    public var topPadding: CGFloat {
        TLCStyle.topPadding
    }
    
    public var textMargin: CGFloat {
        13
    }
    
    public static let elementMargin: CGFloat = 12
    public var elementMargin: CGFloat { TLCStyle.elementMargin }
    
    public static let elementPadding: CGFloat = 8
    public var elementPadding: CGFloat { TLCStyle.elementPadding }
    
    public var cornerRadius: CGFloat {
        10
    }
        
    public var textAreaCornerRadius: CGFloat {
        5
    }
    
    // MARK: - Metrics
    
    
    public static let collectionMargin: CGFloat = 12
    
    public static let cornerRadius: CGFloat = 10
    public static let textCornerRadius: CGFloat = 5
    
    public static let topButtonInsets = UIEdgeInsets(top: TLCStyle.elementMargin, left: TLCStyle.elementMargin*3, bottom: TLCStyle.elementMargin, right: TLCStyle.elementMargin*3)
    
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
    
    public static let textBorderColor = ColorPallet.mediumGrey
    public static let viewBorderColor = ColorPallet.darkGrey
    
    public static let placeholderTextColor = ColorPallet.mediumGrey

    public static let linkColor = ColorPallet.turquoise
    
    public static let primaryBackgroundColor = ColorPallet.lightGrey
    public static let secondaryBackgroundColor = ColorPallet.offWhite

    public static let progressIconColor = ColorPallet.turquoise
    public static let modificationIconColor = ColorPallet.yellow
    public static let destructiveIconColor = ColorPallet.red
    
//    public static let placeholderFont = UIFont(name: TextStyle.label.fontName, size: TextStyle.label.size)
    
    
    
//    private static var bundle = Bundle(for: RealmSubjects.self)
    
    // New
    public static let bannerViewColor = UIColor(named: "Base6", in: bundle, compatibleWith: nil)
    public static let searchBackgroundColor = UIColor(named: "Base5", in: bundle, compatibleWith: nil)
    
    public static let titleTextColor = UIColor(named: "WhiteBase1", in: bundle, compatibleWith: nil)
    
    public static let itemBackgroundColor = UIColor(named: "Base4", in: bundle, compatibleWith: nil) // UIColor(rgb: 0x3E5E66)

    public static let itemIconColor = UIColor(named: "WhiteBase3", in: bundle, compatibleWith: nil) // UIColor(rgb: 0x3E5E66)

    public static let shadowColor = ColorPallet.mediumGrey
    public var shadowColor: UIColor {
        TLCStyle.shadowColor
    }
    
    // Nav Bar
    public static let navBarBackgroundColor = ColorPallet.lightCyan
    
//    public static let navBarStyle = Text
    
    
    
    
}

extension TLCStyle: ColorStyle {
    public var primaryColor: UIColor {
        ColorAssets.accent1.color
    }

    public var secondaryColor: UIColor {
        ColorAssets.accent2.color
    }

    public var baseBackgroundColor: UIColor {
        ColorAssets.whitebase2.color
    }

    public static let acceptButtonBackgroundColor = ColorAssets.accent4.color
    public var acceptButtonBackgroundColor: UIColor {
        TLCStyle.acceptButtonBackgroundColor
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
    
    public static let titleTextAccentColor = ColorAssets.accent3.color
    public var titleTextAccentColor: UIColor {
        TLCStyle.titleTextAccentColor
    }
    
    public static let darkBackgroundTextColor = ColorAssets.whitebase1.color

    
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



extension TLCStyle: FontStyle {
    public var placeholderTextAttributes: [NSAttributedString.Key : Any] {
        return TextStyle.itemTitleStyle.asAttributes
    }
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

public enum FontBook: String {
    case navigation = "KohinoorTelugu-Medium"
    case barButton = "AvenirNext-Regular"
    case header = "Avenir-Medium"
    
    case regular = "AppleSDGothicNeo-Regular"
    case light = "AppleSDGothicNeo-Light"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont.init(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


public struct TextStyle {
    public static let navBarStyle = NewTextStyle(font: FontBook.navigation.of(size: 22), color: TLCStyle.ColorPallet.darkGrey)
    public static let barButtonStyle = NewTextStyle(font: FontBook.navigation.of(size: 16), color: TLCStyle.ColorPallet.darkGrey)
    
    public static let title = NewTextStyle(font: FontBook.regular.of(size: 32),
                                                 color: TLCStyle.ColorPallet.black)
    
    public static let header = NewTextStyle(font: FontBook.header.of(size: 24),
                                                 color: TLCStyle.ColorPallet.darkGrey)
    
    
    public static let categoryWidgetStyle = NewTextStyle(font: FontBook.light.of(size: 13),
                                                         color: TLCStyle.ColorPallet.black)
    
    public static let itemTitleStyle = NewTextStyle(font: FontBook.light.of(size: 16),
                                                    color: TLCStyle.ColorPallet.black) // .label
    
    public static let itemDetailStyle = NewTextStyle(font: FontBook.light.of(size: 13),
                                                    color: TLCStyle.ColorPallet.black) // .subLabel
    
    
    
    public static let setupInstruction = NewTextStyle(font: FontBook.regular.of(size: 16),
                                                           color: TLCStyle.ColorPallet.darkGrey) // .subLabel
    
    public static let finePrint = NewTextStyle(font: FontBook.light.of(size: 11),
                                                           color: TLCStyle.ColorPallet.black) // .subLabel
    
}
