//
//  EditCategoryViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import ClassicClient
import TLCModel

class EditCategoryViewController: UIViewController {

    private let databaseObject: ItemCategory?
    private let mockObject: MockCategory
        
    private var previewCellView: CategoryCellView?
    private let titleContentView = TitleContentView()
    
    weak var delegate: CompletableActionDelegate?
    
    init(category: ItemCategory?) {
        mockObject = MockCategory(category: category)
        databaseObject = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let contentView = UIView()
        
        // Cell Preview
        let previewCell = UIView.instanceFromNib("CategoryCellView", inBundle: Bundle.main) as! CategoryCellView
        previewCellView = previewCell
        
        previewCell.displayCategory(displayable: mockObject)
        previewCell.translatesAutoresizingMaskIntoConstraints = false
        previewCell.layer.cornerRadius = 10
        
        // Edit Area Title Content
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
                
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        titleContentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleContentView.rightTitleItem = saveButton
        titleContentView.leftTitleItem = cancelButton

//        titleContentView.titleLabel.text = "asdas"
        
        titleContentView.layer.cornerRadius = 10

        // Editable Fields
        let editableFieldsController = EditableFieldsViewController()
        self.addChild(editableFieldsController)
        
        editableFieldsController.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        editableFieldsController.view.translatesAutoresizingMaskIntoConstraints = false
        
        editableFieldsController.addField(.shortText(title: "Name", initialValue: mockObject.title, onUpdate: { [weak self] newVal in
            
            if let mockObject = self?.mockObject {
                mockObject.title = newVal
                self?.previewCellView?.displayCategory(displayable: mockObject)
            }
        }))
        
        editableFieldsController.addField(.color(onUpdate: { [weak self] newCol in
            
            if let mockObject = self?.mockObject {
                mockObject.color = newCol
                self?.previewCellView?.displayCategory(displayable: mockObject)
            }
        }))
        
        titleContentView.contentView.addSubview(editableFieldsController.view)
        titleContentView.contentView.constrainSubviewToBounds(editableFieldsController.view)
        
        // Page Layout
        contentView.addSubview(previewCell)
        contentView.addSubview(titleContentView)
        
        let views = ["preview" : previewCell, "edit" : titleContentView]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[preview]-(15)-[edit(200)]", options: .alignAllCenterX, metrics: nil, views: views))
        
        contentView.constrainSubviewToBounds(previewCell, onEdges: [.left, .right])
        contentView.constrainSubviewToBounds(titleContentView, onEdges: [.left, .right])
        
        view.addSubview(contentView)
        view.constrainSubviewToBounds(contentView, onEdges: [.top, .right, .left, .bottom], withInset: UIEdgeInsets.init(top: 200, left: 15, bottom: 0, right: 15))
                
        // Blur Background
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(blurEffectView)
        view.constrainSubviewToBounds(blurEffectView)
        
        view.sendSubviewToBack(blurEffectView)
    }
    
    @objc
    func saveItem() {
        if let itemCategory = databaseObject {
            RealmSubjects.shared.updateCategory(category: itemCategory, usingMock: mockObject)
        } else {
            RealmSubjects.shared.addCategory(withMock: mockObject)
        }
        
        close()
    }
        
    @objc
    func close() {
        delegate?.complete()
    }
}

