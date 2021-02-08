//
//  EditCategoryViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public class EditCategoryViewController: UIViewController {

    private let databaseObject: ItemCategory?
    private let mockObject: MockCategory
        
    private var previewCellView: CategoryCellView?
    
    public weak var delegate: CompletableActionDelegate?
    
    public init(category: ItemCategory?) {
        mockObject = MockCategory(category: category)
        databaseObject = category
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
  
        self.hideKeyboardWhenTappedAround()
        
        // Page Layout
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding
        
        // Edit View
        let editLabel = UILabel()
        editLabel.text = "Edit"
        editLabel.style(TextStyle.heading)
        
        let editView = createEditView()
        
        stack.addArrangedSubview(editLabel)
        stack.addArrangedSubview(editView)
        
        // Preview
        let previewLabel = UILabel()
        previewLabel.text = "Category Preview"
        previewLabel.style(TextStyle.heading)
        
        let previewView = createPreviewView()
        
        stack.addArrangedSubview(previewLabel)
        stack.addArrangedSubview(previewView)
        
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
    
    private func createPreviewView() -> UIView {
        // Cell Preview
        let previewCell = CategoryCellView()
        previewCellView = previewCell
        
        previewCell.displayCategory(displayable: mockObject)
        previewCell.translatesAutoresizingMaskIntoConstraints = false
        previewCell.layer.cornerRadius = 10
        
        return previewCell
    }
    
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
                
        titleContentView.addConstraint(NSLayoutConstraint.init(item: titleContentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))

        // Editable Fields
        var fields: [Field] = []
        
        fields.append(ShortTextField(title: "Name", initialValue: mockObject.title, onUpdate: { [weak self] newVal in
            
            if let mockObject = self?.mockObject {
                mockObject.title = newVal
                self?.previewCellView?.displayCategory(displayable: mockObject)
            }
        }))
            
        fields.append(ColorField(title: "Color", initialValue: mockObject.color, onUpdate: { [weak self] newCol in
            
            if let mockObject = self?.mockObject {
                mockObject.color = newCol
                self?.previewCellView?.displayCategory(displayable: mockObject)
            }
        }))
        
        let formView = FormView(fields: fields)
        
        formView.setContentCompressionResistancePriority(.required, for: .vertical)
        formView.translatesAutoresizingMaskIntoConstraints = false
        
        titleContentView.contentView.addSubview(formView)
        titleContentView.contentView.constrainSubviewToBounds(formView)
        
        return titleContentView
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

