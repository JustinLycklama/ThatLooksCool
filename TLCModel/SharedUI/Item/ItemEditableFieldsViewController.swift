//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-16.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public class ItemEditableFieldsViewController: UIViewController {

    private let associatedCategory: ItemCategory?
    
    private let databaseObject: Item?
    private let mockObject: MockItem
                
    public weak var completeDelegate: CompletableActionDelegate?
    
    private let editableFieldsController = EditableFieldsViewController()
    private let displaysMap: Bool
    
    public var sizeSubscriber: ((CGSize) -> Void)? {
        didSet {
            editableFieldsController.sizeSubscriber = sizeSubscriber
        }
    }
    
    public init(item: Item?, category: ItemCategory?, displaysMap: Bool = true) {
        mockObject = MockItem(item: item)
        databaseObject = item
        associatedCategory = category
        self.displaysMap = displaysMap
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(item: Item?, mockItem: MockItem, category: ItemCategory?, displaysMap: Bool = false) {
        mockObject = mockItem
        databaseObject = item
        associatedCategory = category
        self.displaysMap = displaysMap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Editable Fields

        editableFieldsController.delegate = self
        self.addChild(editableFieldsController)
        
        editableFieldsController.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        editableFieldsController.view.translatesAutoresizingMaskIntoConstraints = false
        
        editableFieldsController.addField(.shortText(title: "Tag", initialValue: mockObject.title, onUpdate: { [weak self] newVal in
            if let mockObject = self?.mockObject {
                mockObject.title = newVal
            }
        }))
        
        if displaysMap, let coord = mockObject.coordinate {
            editableFieldsController.addField(.map(coordinate: coord))
        }
        
        editableFieldsController.addField(.longText(title: "Notes", initialValue: mockObject.info, onUpdate: { [weak self] newVal in
            if let mockObject = self?.mockObject {
                mockObject.info = newVal
            }
        }))
        
//        editableFieldsController.addField(.list(title: "Categories", values: ["1as ", "2sd as d"]))
        
        editableFieldsController.completeFieldSetup()

        self.view.addSubview(editableFieldsController.view)
        self.view.constrainSubviewToBounds(editableFieldsController.view)
        
        editableFieldsController.sizeSubscriber = { [weak self] requestedSize in
            guard let view = self?.editableFieldsController.view else {
                return
            }
            
            let heightConstraint = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: requestedSize.height)
            
            heightConstraint.priority = .defaultHigh
            view.addConstraint(heightConstraint)
        }
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
        
    @objc
    public func complete() {
        completeDelegate?.complete()
    }
}

extension ItemEditableFieldsViewController: ExternalApplicationRequestDelegate {
    func requestMapApplication(forCoordinate coordinate: Coordinate) {
        
        if let item = databaseObject {
            RealmSubjects.shared.setOutItem(item: item)
        }
        
        let lat = coordinate.coreLocationCoordinate.latitude
        let lon = coordinate.coreLocationCoordinate.longitude
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            print("Cannot open maps")
            
            if let urlDestination = URL.init(string: "https://www.google.com/maps/?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)"){
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
}

