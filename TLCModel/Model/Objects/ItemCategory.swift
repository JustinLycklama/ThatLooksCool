//
//  Category.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift

public protocol CategoryDisplayable {
    var title: String { get }
    var color: UIColor { get }
    var icon: TLCCategoryIconSet { get }
}

public class ItemCategory: Object, CategoryDisplayable {

    @objc public dynamic var id: String
    @objc public dynamic var title: String
    @objc public dynamic var colorHex: String
    @objc public dynamic var iconIdentifier: String
    
    public var icon: TLCCategoryIconSet {
        get {
            TLCCategoryIconSet.init(rawValue: iconIdentifier) ?? TLCCategoryIconSet.defaultIcon
        }
        set {
            iconIdentifier = newValue.rawValue
        }
    }

    public var color: UIColor {
        get {
            UIColor.init(hex: colorHex) ?? .white
        }
        set {
            colorHex = newValue.toHex() ?? "FFFFFF"
        }
    }
    
    public init(mock: MockCategory) {
        id = UUID().uuidString
        self.title = mock.title
        self.colorHex = mock.color.toHex() ?? "FFFFFF"
        self.iconIdentifier = mock.icon.rawValue
    }
    
    public required override init() {
        id = UUID().uuidString
        self.title = "<Undefined>"
        self.colorHex = "e81ade"
        self.iconIdentifier = TLCCategoryIconSet.defaultIcon.rawValue
    }
    
    public func update(usingMock mock: MockCategory) {
        self.title = mock.title
        self.color = mock.color
        self.icon = mock.icon
    }
    
    static func ==(lhs: ItemCategory, rhs: ItemCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

public class MockCategory: CategoryDisplayable {
    public var title: String
    public var color: UIColor
    public var icon: TLCCategoryIconSet
    
    public init(category: ItemCategory?) {
        title = category?.title ?? "New Category"
        color = category?.color ?? UIColor.white
        icon = category?.icon ?? TLCCategoryIconSet.defaultIcon
    }
}
