//
//  EditCategoryView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-03-29.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class EditCategoryView: UIView {

    var category: ItemCategory
    var mockCategory: MockCategory
    
    weak var delegate: CompletableActionDelegate?
    
    private lazy var categoryBadge: CategoryWidget = {
        let widget = CategoryWidget()
        widget.titleLabel.style(TextStyle.categoryWidgetStyle + TLCStyle.darkBackgroundTextColor)
//        widget.styleTitle(TextStyle.accentLabel)
        widget.displayCategory(displayable: mockCategory)
        
        widget.addConstraint(.init(item: widget, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TLCStyle.categoryWidgetDesiredSize.width))

        return widget
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.style(TextStyle.itemTitleStyle)
        textField.text = mockCategory.title
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var deleteButton: Button = {
        let button = Button()
        button.backgroundColor = TLCStyle.destructiveIconColor
        button.title = "Delete"
        button.action = { [weak self] button in
            guard let self = self else {
                return
            }
            
            button.setEnabled(false)
            self.category.remove()
            self.delegate?.complete()
        }
        
        return button
    }()
    
    private lazy var categoryIconList: UIView = {
        
        let itemSet = TLCCategoryIconSet.allCases
        
        let actionCellConfig = CollectionCellConfig<Void, AddCategoryCollectionCell> (performAction: nil)
        
        let iconCellConfig = CollectionCellConfig { (icon: TLCCategoryIconSet, cell: IconCollectionCell) in
            cell.setImage(icon.image())
        } performAction: { [weak self]  (icon: TLCCategoryIconSet) in
            self?.mockCategory.icon = icon
            self?.saveCategory()
        }
        
        let grid = ActionableGridView(actionConfig: actionCellConfig, itemConfig: iconCellConfig, itemWidth: 32)
                
        grid.spacing = 2
        grid.setItems(items: TLCCategoryIconSet.allCases)
        
        if let index = itemSet.firstIndex(of: category.icon) {
            grid.setSelected(index: index)
        }
        
        grid.backgroundColor = .white
        grid.layer.cornerRadius = TLCStyle.cornerRadius
        
        grid.addConstraint(.init(item: grid, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        return grid
    }()
    
    init(category: ItemCategory) {
        self.category = category
        self.mockCategory = MockCategory(category: category)
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(createBadgeArea())
        stack.addArrangedSubview(createEditArea())

        self.addSubview(stack)
    //        view.constrainSubviewToBounds(stack, onEdges: [.top, .left, .right] , withInset: UIEdgeInsets(TLCStyle.topMargin))
    //        view.constrainSubviewToBounds(stack, onEdges: [.left])

        self.constrainSubviewToBounds(stack)
        
    }
    
    private func createBadgeArea() -> UIView {
        let container = UIView()
        
        let bannerBackground = ShadowView()
        bannerBackground.backgroundColor = TLCStyle.bannerViewColor
        bannerBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        bannerBackground.layer.cornerRadius = TLCStyle.cornerRadius
        
        let view = UIView()

        view.addSubview(categoryBadge)
        view.constrainSubviewToBounds(categoryBadge, withInset: UIEdgeInsets(0))
        
        bannerBackground.addSubview(view)
        bannerBackground.constrainSubviewToBounds(view, withInset: UIEdgeInsets(TLCStyle.topPadding))

        container.addSubview(bannerBackground)
        container.constrainSubviewToBounds(bannerBackground, onEdges: [.left, .right])
        
        container.addConstraint(.init(item: bannerBackground, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0))
        
        return container
    }
    
    private func createEditArea() -> UIView {
        let container = UIView()
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.elementMargin
        
        let titleDeleteStack = UIStackView()
        titleDeleteStack.axis = .horizontal
        titleDeleteStack.spacing = TLCStyle.elementPadding
        titleDeleteStack.distribution = .fill
        
        let titleContainer = UIView()
        titleContainer.addSubview(categoryNameTextField)
        titleContainer.constrainSubviewToBounds(categoryNameTextField, onEdges: [.top, .bottom], withInset: UIEdgeInsets(TLCStyle.textInset))
        titleContainer.constrainSubviewToBounds(categoryNameTextField, onEdges: [.left, .right], withInset: UIEdgeInsets(TLCStyle.textInset))
        
        titleDeleteStack.addArrangedSubview(deleteButton)
        titleDeleteStack.addArrangedSubview(titleContainer)
//        titleDeleteStack.addArrangedSubview(UIView())

//        titleContainer.addSubview(deleteButton)
//        titleContainer.constrainSubviewToBounds(deleteButton, onEdges: [.top, .bottom], withInset: UIEdgeInsets(TLCStyle.textInset))
//        titleContainer.constrainSubviewToBounds(deleteButton, onEdges: [.right], withInset: UIEdgeInsets(TLCStyle.textInset))

//        titleDeleteStack.addConstraint(.init(item: categoryNameTextField, attribute: .right, relatedBy: .equal, toItem: deleteButton, attribute: .left, multiplier: 1, constant: -TLCStyle.elementPadding))
//        titleDeleteStack.addConstraint(.init(item: categoryNameTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 102))
        
        titleContainer.backgroundColor = .white
        titleContainer.layer.cornerRadius = TLCStyle.textCornerRadius
        
        stack.addArrangedSubview(titleDeleteStack)
        
        let iconContainer = UIView()
        iconContainer.addSubview(categoryIconList)
        iconContainer.constrainSubviewToBounds(categoryIconList, onEdges: [.top, .bottom], withInset: UIEdgeInsets(TLCStyle.textInset))
        iconContainer.constrainSubviewToBounds(categoryIconList, onEdges: [.left, .right], withInset: UIEdgeInsets(TLCStyle.textInset))

        iconContainer.backgroundColor = .white
        iconContainer.layer.cornerRadius = TLCStyle.textCornerRadius
        
        stack.addArrangedSubview(iconContainer)
        
        container.addSubview(stack)
        container.constrainSubviewToBounds(stack, onEdges: [.left, .right])
        
        container.addConstraint(.init(item: stack, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0))
        
        return container
    }
    
    private func saveCategory() {        
        categoryBadge.displayCategory(displayable: category.update(usingMock: mockCategory))
    }
}

extension EditCategoryView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        if newText.count <= TLCStyle.categoryMaxTitleLength {
            mockCategory.title = newText
            saveCategory()
            return true
        }
        
        return false
    }
}