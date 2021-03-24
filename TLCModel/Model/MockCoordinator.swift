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
