//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-16.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

//
//  EditCategoryViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

//TODO REMOVE
import CoreLocation

import TLCModel

class EditItemViewController: UIViewController {

    private let associatedCategory: ItemCategory?
    
    private let databaseObject: Item?
    private let mockObject: MockItem
        
//    private let titleContentView = TitleContentView()
    
    let scrollView = UIScrollView()
    
    
    weak var completeDelegate: CompletableActionDelegate?
    
    init(item: Item?, category: ItemCategory?) {
        mockObject = MockItem(item: item)
        databaseObject = item
        associatedCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
//        let contentView = UIView()
        
        
        // Edit Area Title Content
//        let saveButton = UIButton()
//        saveButton.setTitle("Save", for: .normal)
//        saveButton.setTitleColor(.black, for: .normal)
//        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
//
//        let cancelButton = UIButton()
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.setTitleColor(.black, for: .normal)
//        cancelButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
//        titleContentView.translatesAutoresizingMaskIntoConstraints = false
//
//        titleContentView.rightTitleItem = saveButton
//        titleContentView.leftTitleItem = cancelButton
//
////        titleContentView.titleLabel.text = "asdas"
//
//        titleContentView.layer.cornerRadius = 10

        // Editable Fields
        let editableFieldsController = EditableFieldsViewController()
        self.addChild(editableFieldsController)
        
        editableFieldsController.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        editableFieldsController.view.translatesAutoresizingMaskIntoConstraints = false
        
        editableFieldsController.addField(.shortText(title: "Name", initialValue: mockObject.title, onUpdate: { [weak self] newVal in
            if let mockObject = self?.mockObject {
                mockObject.title = newVal
            }
        }))
        
        if let coord = mockObject.coordinate {
            editableFieldsController.addField(.map(coordinate: coord))
        }
        
        editableFieldsController.addField(.longText(title: "Info", initialValue: mockObject.info, onUpdate: { [weak self] newVal in
            if let mockObject = self?.mockObject {
                mockObject.info = newVal
            }
        }))

        self.view.addSubview(editableFieldsController.view)
        self.view.constrainSubviewToBounds(editableFieldsController.view)
        
    
//        scrollView.backgroundColor = .cyan
//
//        scrollView.addSubview(editableFieldsController.view)
//        scrollView.constrainSubviewToBounds(editableFieldsController.view)
//
//
//        self.view.addSubview(scrollView)
//        self.view.constrainSubviewToBounds(scrollView)
//
        
        ////////////
        
//        titleContentView.contentView.addSubview(editableFieldsController.view)
//        titleContentView.contentView.constrainSubviewToBounds(editableFieldsController.view)
        
        // Page Layout
//        contentView.addSubview(previewCell)
//        contentView.addSubview(titleContentView)
//
//        let views = ["preview" : previewCell, "edit" : titleContentView]
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[preview]-(15)-[edit(200)]", options: .alignAllCenterX, metrics: nil, views: views))
//
//        contentView.constrainSubviewToBounds(previewCell, onEdges: [.left, .right])
//        contentView.constrainSubviewToBounds(titleContentView, onEdges: [.left, .right])
        
//        view.addSubview(titleContentView)
//        view.constrainSubviewToBounds(titleContentView, onEdges: [.top, .right, .left, .bottom], withInset: UIEdgeInsets.init(top: 200, left: 15, bottom: 0, right: 15))
//
//        // Blur Background
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(blurEffectView)
//        view.constrainSubviewToBounds(blurEffectView)
//
//        view.sendSubviewToBack(blurEffectView)
    }
    
    @objc @discardableResult
    func saveItem() -> Item {
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
    func deleteItem() -> MockItem? {
        var deletedItem: MockItem? = nil
        
        if let item = databaseObject {
            deletedItem = MockItem(item: item)
            RealmSubjects.shared.removeItem(item)
        }
        
        complete()
        return deletedItem
    }
        
    @objc
    func complete() {
        completeDelegate?.complete()
    }
}


