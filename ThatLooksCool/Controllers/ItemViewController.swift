//
//  ItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-02-28.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class ItemViewController: UIViewController {
        
//    private var previewCellView: ItemCellView?
    
    let formView: FormView
    let itemMockCoordinator: MockItemCoordinator
    
    weak var delegate: CompletableActionDelegate?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // TLCStyle.primaryBackgroundColor
//        view.alpha = 0.88
        
        return view
    }()
    
//    private lazy var itemTitleTextField: UITextField = {
//       let textField = UITextField()
//
//        return textField
//    }()
//
  
    private lazy var mapView: UIView = {
        let view = MapView()
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.subLabel)
        label.textAlignment = .right
        
        label.text = "12345"
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var categoryIcon: UIView = {
        let icon = CategoryIcon(category: nil, borderColor: .clear)
        
        return icon
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = TLCStyle.topButtonInsets
        button.backgroundColor = TLCStyle.progressIconColor
        button.layer.cornerRadius = TLCStyle.cornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitle("Save", for: .normal)
        
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = TLCStyle.topButtonInsets
        button.backgroundColor = TLCStyle.destructiveIconColor
        button.layer.cornerRadius = TLCStyle.cornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitle("Delete", for: .normal)
        
        return button
    }()
    
    init(item: Item?, category: ItemCategory) {
        itemMockCoordinator = MockItemCoordinator(item: item, category: category)
        formView = FormView(fields: itemMockCoordinator.modifiableFields())
        formView.backgroundColor = .clear
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.view.backgroundColor = .clear
        self.hideKeyboardWhenTappedAround()
        
        self.view.addSubview(backgroundView)
        self.view.constrainSubviewToBounds(backgroundView, onEdges: [.left, .right])
        self.view.constrainSubviewToBounds(backgroundView, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.safeArea.bottom + 125))

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(mapView)
        stack.addArrangedSubview(createItemInfoView())
        stack.addArrangedSubview(createSaveDelete())
        
        backgroundView.addSubview(stack)
        backgroundView.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(TLCStyle.elementMargin))
    }

    private func createItemInfoView() -> UIView {
        let accentView = AccentView()
        
        formView.setContentCompressionResistancePriority(.required, for: .vertical)
        accentView.setPrimaryView(formView)
                
        let categoryContainer = UIView()
        
        let categoryStack = UIStackView()
        categoryStack.axis = .horizontal
        categoryStack.spacing = TLCStyle.elementPadding
        
        categoryStack.addArrangedSubview(categoryLabel)
        categoryStack.addArrangedSubview(categoryIcon)
        
        categoryContainer.addSubview(categoryStack)
        categoryContainer.constrainSubviewToBounds(categoryStack, onEdges: [.left, .right])
        categoryContainer.addConstraint(.init(item: categoryStack, attribute: .centerY, relatedBy: .equal, toItem: categoryContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        accentView.setSecondaryView(categoryContainer)
        
//        accentView.addConstraint(.init(item: accentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150))
        
        return accentView
    }
    
    private func createSaveDelete() -> UIView {
//        let container = UIView()
        
        let stack = UIStackView()
        stack.axis = .horizontal
        
        let leftSpacer = UIView()
        let middleSpacer = UIView()
        let rightSpacer = UIView()
                
        stack.addArrangedSubview(leftSpacer)
        stack.addArrangedSubview(deleteButton)
        stack.addArrangedSubview(middleSpacer)
        stack.addArrangedSubview(saveButton)
        stack.addArrangedSubview(rightSpacer)

        stack.addConstraint(.init(item: leftSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
        stack.addConstraint(.init(item: middleSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
        
//        container.addSubview(stack)
//        container.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(TLCStyle.topMargin))
                
        return stack
    }
    
    private var contentHeightConstraint: NSLayoutConstraint?
    
    @objc
    func saveItem() {
//        itemMockCoordinator.saveItem()
        
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
