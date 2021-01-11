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
}

public class ItemCategory: Object, CategoryDisplayable {

    @objc public dynamic var id: String
    @objc public dynamic var title: String
    @objc public dynamic var colorHex: String
    
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
    }
    
    required override init() {
        id = UUID().uuidString
        self.title = "<Undefined>"
        self.colorHex = "e81ade"
    }
    
    public func update(usingMock mock: MockCategory) {
        self.title = mock.title
        self.color = mock.color
    }
    
    static func ==(lhs: ItemCategory, rhs: ItemCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

public class MockCategory: CategoryDisplayable {
    public var title: String
    public var color: UIColor
    
    public init(category: ItemCategory?) {
        title = category?.title ?? ""
        color = category?.color ?? UIColor.white
    }
}
