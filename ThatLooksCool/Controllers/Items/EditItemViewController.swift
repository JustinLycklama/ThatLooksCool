//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-06.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class EditItemViewController: UIViewController {
        
    private var previewCellView: ItemCellView?
    
    let formView: FormView
    let itemMockCoordinator: MockItemCoordinator
    
    weak var delegate: CompletableActionDelegate?
    
    init(item: Item?, category: ItemCategory) {
        itemMockCoordinator = MockItemCoordinator(item: item, category: category)
        formView = FormView(fields: itemMockCoordinator.modifiableFields())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.hideKeyboardWhenTappedAround()
        
        // Page Layout
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding
        
        // Preview
//        let previewLabel = UILabel()
//        previewLabel.text = "Item Preview"
//        previewLabel.style(.heading)
//
//        let previewView = createPreviewView()
//
//        stack.addArrangedSubview(previewLabel)
//        stack.addArrangedSubview(previewView)
        
        // Edit View
        let editLabel = UILabel()
        editLabel.text = "Edit"
        editLabel.style(TextStyle.heading)
        
        let editView = createEditView()
        
//        stack.addArrangedSubview(editLabel)
        stack.addArrangedSubview(editView)
        
        view.addSubview(stack)
        view.constrainSubviewToBounds(stack, onEdges: [.top, .left, .right],
                                      withInset: UIEdgeInsets.init(top: TLCStyle.topLevelMargin + TLCStyle.topLevelPadding,
                                                                   left: TLCStyle.topLevelMargin,
                                                                   bottom: 0,
                                                                   right: TLCStyle.topLevelMargin))
        
        // Blur Background
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(blurEffectView)
        view.constrainSubviewToBounds(blurEffectView)
        
        view.sendSubviewToBack(blurEffectView)
    }
    
//    private func createPreviewView() -> UIView {
//        // Cell Preview
//        let previewCell = UIView.instanceFromNib("ItemCellView", inBundle: Bundle.main) as! ItemCellView
//        previewCellView = previewCell
//
//        previewCell.displayItem(displayable: editableFieldsController.mo)
//        previewCell.translatesAutoresizingMaskIntoConstraints = false
//        previewCell.layer.cornerRadius = 10
//
//        return previewCell
//    }
    
    private var contentHeightConstraint: NSLayoutConstraint?
    
    private func createEditView() -> UIView {
        
        let titleContentView = TitleContentView()
        
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
        
        titleContentView.layer.cornerRadius = TLCStyle.cornerRadius
        titleContentView.layer.borderWidth = 1
        titleContentView.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        // Editable Fields
//        self.addChild(editableFieldsController)
        
        titleContentView.contentView.addSubview(formView)
        titleContentView.contentView.constrainSubviewToBounds(formView)
        
        return titleContentView
    }
    
    @objc
    func saveItem() {
        itemMockCoordinator.saveItem()
        
//        if let itemCategory = databaseObject {
//            RealmSubjects.shared.updateCategory(category: itemCategory, usingMock: mockObject)
//        } else {
//            RealmSubjects.shared.addCategory(withMock: mockObject)
//        }
        
        close()
    }
        
    @objc
    func close() {
        delegate?.complete()
    }
}
