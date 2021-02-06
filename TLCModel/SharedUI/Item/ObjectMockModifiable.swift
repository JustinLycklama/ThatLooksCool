//
//  ObjectMockModifiable.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-05.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import Foundation

protocol ModifiableFieldsMockCoordinator {
    
    associatedtype ObjectType: AnyObject
    associatedtype MockType: AnyObject
    
    // Returns a reference to the saved item
    func saveItem() -> ObjectType
    
    // Returns a mock of the deleted item
    func deleteItem() -> MockType?
}


class ItemModifier: ModifiableFieldsMockCoordinator {
    private let associatedCategory: ItemCategory?
    
    private let databaseObject: Item?
    private let mockObject: MockItem
                
    public weak var completeDelegate: CompletableActionDelegate?
    
    convenience init(item: Item?, category: ItemCategory?) {
        let mockObject = MockItem(item: item)
        self.init(item: item, mockItem: mockObject, category: category)
    }
    
    public init(item: Item?, mockItem: MockItem, category: ItemCategory?) {
        mockObject = mockItem
        databaseObject = item
        associatedCategory = category
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
