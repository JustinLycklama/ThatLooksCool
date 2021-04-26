//
//  ItemDetailView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class ItemDetailView: UIView {

    let itemMockCoordinator: MockItemCoordinator

    init(item: Item) {
        itemMockCoordinator = MockItemCoordinator(item: item, category: item.category)
        
        super.init(frame: .zero)
        setup()
    }
    
    init(mock: MockItem) {
        itemMockCoordinator = MockItemCoordinator(item: nil, mockItem: mock, category: nil)

        super.init(frame: .zero)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let accentView = AccentView()

        let formView = FormView(fields: itemMockCoordinator.modifiableFields())
        formView.setContentCompressionResistancePriority(.required, for: .vertical)
        accentView.setPrimaryView(formView)

        let categoryContainer = UIView()
        //
        let categoryStack = UIStackView()
        categoryStack.axis = .horizontal
        categoryStack.spacing = TLCStyle.elementPadding
        
        categoryStack.addArrangedSubview(categoryLabel)
        categoryStack.addArrangedSubview(categoryIcon)
        
        categoryContainer.addSubview(categoryStack)
        categoryContainer.constrainSubviewToBounds(categoryStack, onEdges: [.left, .right])
        categoryContainer.addConstraint(.init(item: categoryStack, attribute: .centerY, relatedBy: .equal, toItem: categoryContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        accentView.setSecondaryView(categoryContainer)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(mapView)
        stack.addArrangedSubview(accentView)
        
        self.addSubview(stack)
        self.constrainSubviewToBounds(stack)
//
    //        accentView.addConstraint(.init(item: accentView, attribute: .height, relatedBy: .equal, toItem: formView, attribute: .height, multiplier: 1, constant: 0))
//
        
    }
    
    // MARK: Map
    
    private lazy var mapView: UIView = {
        let view = MapView()
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        
        return view
    }()
    
    // MARK: Item Info
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.itemDetailStyle)
        label.textAlignment = .right
        
        label.text = "12345"
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private lazy var categoryIcon: UIView = {
        let icon = CategoryIcon()
//        icon.image = itemMockCoordinator.associatedCategory?.icon.image()
        
        return icon
    }()
    
    func saveChanges() {
        itemMockCoordinator.saveItem()
    }
    
    func delete() {
        itemMockCoordinator.deleteItem()
    }
    
}
