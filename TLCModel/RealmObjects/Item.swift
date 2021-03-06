//
//  Item.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2020-12-17.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift

public protocol ItemDisplayable: AnyObject {
    var title: String? { get }
    var info: String? { get }
    var coordinate: Coordinate? { get }
}

public class Item: Object, ItemDisplayable {
    
    @objc public dynamic var id: String
    @objc public dynamic var title: String?
    @objc public dynamic var info: String?
    @objc public dynamic var coordinate: Coordinate?
    @objc public dynamic var category: ItemCategory?
    
    @objc public dynamic let timestamp: Date?
    
    public init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        
        timestamp = Date()
    }
    
    public init(coordinate: Coordinate) {
        self.id = UUID().uuidString
        self.title = ""
        self.coordinate = coordinate
        
        self.timestamp = Date()
    }
    
    public init(mock: MockItem, category: ItemCategory?) {
        self.id = UUID().uuidString
        self.title = mock.title
        self.info = mock.info
        self.coordinate = mock.coordinate
        self.category = category
        
        self.timestamp = Date()
    }
    
    required override init() {
        self.id = UUID().uuidString
        self.title = "<Undefined>"
        coordinate = nil
        timestamp = Date()
    }
    
    public func update(usingMock mock: MockItem) {
        self.title = mock.title
        self.info = mock.info
        self.coordinate = mock.coordinate
    }
    
    public func updateCategory(_ category: ItemCategory?) {
        self.category = category
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if self.isInvalidated || (object as? Object)?.isInvalidated ?? false {
            return false
        }
        
        if let otherItem = object as? Item {
            return self == otherItem
        }

        return false
    }

    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

public class MockItem: ItemDisplayable {
    public var title: String?
    public var info: String?
    public var coordinate: Coordinate?

    public init(item: Item?) {
        title = item?.title
        info = item?.info
        coordinate = item?.coordinate
    }
}
