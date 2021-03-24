//
//  Item.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2020-12-17.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift
import ClassicClient

public protocol ItemDisplayable: AnyObject {
    var title: String? { get }
    var info: String? { get }
    var coordinate: Coordinate? { get }
    var timestamp: Date? { get }
}

public class Item: Object, ItemDisplayable {
    
    @objc public dynamic var id: String
    @objc public dynamic var title: String?
    @objc public dynamic var info: String?
    @objc public dynamic var coordinate: Coordinate?
    @objc public dynamic var category: ItemCategory?
    
    @objc public dynamic var isSelectedOutItem: Bool = false
    
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
        self.timestamp = mock.timestamp ??  Date()
        self.category = category        
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

// MARK: - Mock

public class MockItem: ItemDisplayable {
    public var title: String?
    public var info: String?
    public var coordinate: Coordinate?
    public var timestamp: Date?

    public init(item: Item?) {
        title = item?.title
        info = item?.info
        coordinate = item?.coordinate
        timestamp = item?.timestamp
    }
}

// MARK: - Coordinator

public class MockItemCoordinator: MockCoordinator {
    
    public typealias ObjectType = Item
    public typealias MockType = MockItem
    
    private let associatedCategory: ItemCategory?
    
    public let databaseObject: Item?
    public let mockObject: MockItem
                
    public weak var completeDelegate: CompletableActionDelegate?
    
    public convenience init(item: Item?, category: ItemCategory? = nil) {
        let mockObject = MockItem(item: item)
        self.init(item: item, mockItem: mockObject, category: category)
    }
    
    public init(item: Item?, mockItem: MockItem, category: ItemCategory?) {
        mockObject = mockItem
        databaseObject = item
        associatedCategory = category
    }
    
    public func modifiableFields() -> [Field] {
        return mockObject.modifiableFields()
    }
    
    @objc @discardableResult
    public func saveItem() -> Item {
        let savedItem: Item!
        
        if let item = databaseObject {
            RealmSubjects.shared.updateItem(item: item, usingMock: mockObject)
            savedItem = item
        } else {
            savedItem = RealmSubjects.shared.createItem(withMock: mockObject, toCategory: associatedCategory)
        }
        
        complete()
        return savedItem
    }
    
    @discardableResult
    public func deleteItem() -> MockItem? {
        var deletedItem: MockItem? = nil
        
        if let item = databaseObject {
            deletedItem = MockItem(item: item)
            RealmSubjects.shared.removeItem(item)
        }
        
        complete()
        return deletedItem
    }
        
    private func complete() {
        completeDelegate?.complete()
    }
}

extension MockItem: ModifiableFields {
    // TODO: Classic client stuff elsewhere?
    public func modifiableFields() -> [Field] {
        var fields: [Field] = []

        fields.append(ShortTextField(title: "Tag", initialValue: title, onUpdate: { [weak self] newVal in
            guard let self = self else {
                return
            }
            
            self.title = newVal
        }))
        

    
        fields.append(LongTextField(title: "Notes", initialValue: info, onUpdate: { [weak self] newVal in
            guard let self = self else {
                return
            }

            self.info = newVal
        }))
        
        return fields
    }
}
