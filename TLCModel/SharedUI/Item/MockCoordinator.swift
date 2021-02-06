//
//  ObjectMockModifiable.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-05.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import ClassicClient

public protocol MockCoordinator {
    
    associatedtype ObjectType: AnyObject
    associatedtype MockType: AnyObject
            
    var databaseObject: ObjectType? { get }
    var mockObject: MockType { get }
    
    // Returns a reference to the saved item
    func saveItem() -> ObjectType
    
    // Returns a mock of the deleted item
    func deleteItem() -> MockType?
}

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
