//
//  CategoryViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-02-19.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class CategoryViewController: AdViewController {

    private lazy var categoryHeader: UIView = {
        let view = UIView()
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(categoryBadge)
        stack.addArrangedSubview(editableCategoryArea)

        view.addSubview(stack)
//        view.constrainSubviewToBounds(stack, onEdges: [.top, .left, .right] , withInset: UIEdgeInsets(TLCStyle.topMargin))
//        view.constrainSubviewToBounds(stack, onEdges: [.left])
  
        view.constrainSubviewToBounds(stack)
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175))
        
        return view
    }()
        
    private lazy var categoryBadge: UIView = {
        let container = UIView()
        
        let bannerBackground = ShadowView()
        bannerBackground.backgroundColor = TLCStyle.bannerViewColor
        bannerBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        bannerBackground.layer.cornerRadius = TLCStyle.cornerRadius
        
        let view = UIView()
//        view.backgroundColor = TLCStyle.primaryBackgroundColor
//        view.layer.cornerRadius = TLCStyle.cornerRadius
        
//        view.addConstraint(.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
        let widget = CategoryWidget()
        widget.styleTitle(TextStyle.accentLabel)
        
        view.addSubview(widget)
        view.constrainSubviewToBounds(widget, withInset: UIEdgeInsets(0))
        
        bannerBackground.addSubview(view)
        bannerBackground.constrainSubviewToBounds(view, withInset: UIEdgeInsets(TLCStyle.topPadding))

        
        
        
        container.addSubview(bannerBackground)
        container.constrainSubviewToBounds(bannerBackground, onEdges: [.left, .right])
        
        container.addConstraint(.init(item: bannerBackground, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0))
        
        return container
    }()
    
    // MARK: - Edit Category
    
    private lazy var editableCategoryArea: UIView = {
        let container = UIView()
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.interiorPadding
        
        stack.addArrangedSubview(categoryNameTextField)
        stack.addArrangedSubview(categoryIconList)
        
        container.addSubview(stack)
        container.constrainSubviewToBounds(stack, onEdges: [.left, .right])
        
        container.addConstraint(.init(item: stack, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0))
        
        return container
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.style(TextStyle.label)
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var categoryIconList: UIView = {
        
        let iconCellConfig = CollectionCellConfig { (image: UIImage, cell: IconCollectionCell) in
            cell.setImage(image)
        } performAction: { [weak self]  (image: UIImage) in
            
        }
        
        let grid = ActionableGridView(itemConfig: iconCellConfig)
        
        let items = TLCCategoryIconSet.allCases.compactMap { (icon: TLCCategoryIconSet) -> UIImage? in
            icon.image()
        }
        
        grid.setItems(items: items)
        grid.backgroundColor = .white
        grid.layer.cornerRadius = TLCStyle.cornerRadius
        
        grid.addConstraint(.init(item: grid, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: IconCollectionCell.height * 2))
        
        return grid
    }()
    
    
    // MARK: - Items Table
    
    private lazy var categoryItemsView: UIView = {
        let container = UIView()

        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (item: Item) in
            RealmSubjects.shared.removeItem(item)
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: nil)
        
        let itemCellConfig = TableCellConfig(swipeActions: [deleteSwipAction]) { (item: Item, cell: ItemTableViewCell) in
            cell.displayItem(item: item)
        } performAction: { [weak self]  (item: Item) in
            let itemViewController = ItemViewController(item: item, category: item.category ?? ItemCategory())
            itemViewController.modalPresentationStyle = .formSheet  //.overCurrentContext
            
            self?.present(itemViewController, animated: true, completion: nil)
        }
        
        let itemTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: itemCellConfig)
        
        let cat = ItemCategory()
        cat.title = "Books"
        
        let cat1 = Item(title: "1")
        let cat2 = Item(title: "The Expanse")
        cat2.updateCategory(cat)
        cat2.info = "A sci fi show"
        let cat3 = Item(title: "3")
        let cat4 = Item(title: "4")
        let cat5 = Item(title: "5")
        let cat6 = Item(title: "6")
        let cat7 = Item(title: "7")

        let cat8 = Item(title: "3")
        let cat9 = Item(title: "4")
        let cat10 = Item(title: "5")
        let cat11 = Item(title: "6")
        let cat12 = Item(title: "7")
        
        
        itemTable.setItems(items: [cat1, cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9, cat10, cat11, cat12])
                
        container.addSubview(itemTable)
        container.constrainSubviewToBounds(itemTable, onEdges: [.left, .right, .bottom], withInset: UIEdgeInsets(TLCStyle.topPadding))
        container.constrainSubviewToBounds(itemTable, onEdges: [.top])
        
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(categoryHeader)
        stack.addArrangedSubview(categoryItemsView)
        
        self.contentArea.addSubview(stack)
        self.contentArea.constrainSubviewToBounds(stack)
    }
}

extension CategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        return newText.count <= TLCStyle.categoryMaxTitleLength
    }
}
