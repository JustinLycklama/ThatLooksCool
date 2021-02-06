//
//  DisplayCategoriesTableController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-07.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public protocol CompletableWithCategoryDelegate: AnyObject {
    func complete(withCategory category: ItemCategory?)
}

public class DisplayCategoriesTableController: UIViewController {
    
    public weak var delegate: CompletableWithCategoryDelegate?

    public let contentView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        edgesForExtendedLayout = []
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        contentView.backgroundColor = .clear
        
        title = "Categories"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        // Layout
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding

        // Items
        let itemsView = createCategoriesView()
        
        let itemsLabel = UILabel()
        itemsLabel.text = "Category"
        itemsLabel.style(TextStyle.heading)

        stack.addArrangedSubview(itemsLabel)
        stack.addArrangedSubview(itemsView)
        
        contentView.addSubview(stack)
        contentView.constrainSubviewToBounds(stack)
        
        self.view.addSubview(contentView)
        self.view.constrainSubviewToBounds(contentView, withInset: UIEdgeInsets(TLCStyle.topLevelMargin))
        
        addBackgroundImage()
    }
    
    @objc func close() {
        delegate?.complete(withCategory: nil)
    }
    
    private func createCategoriesView() -> UIView {
        
        let categoriesTableController = CategoriesTableController()
        
        // View Items
        categoriesTableController.title = "View Items By Category"
        categoriesTableController.canAddNewItem = true
        categoriesTableController.delegate = self
    
        self.addChild(categoriesTableController)
        
        let itemsView = categoriesTableController.view!
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        
        let itemsContrainer = UIView()
        itemsContrainer.backgroundColor = .clear
        
        itemsContrainer.addSubview(itemsView)
        itemsContrainer.constrainSubviewToBounds(itemsView, withInset: UIEdgeInsets(top: 0, left: 0, bottom: TLCStyle.topLevelPadding, right: 0))

        return itemsContrainer
    }
}

extension DisplayCategoriesTableController: CategorySelectionDelegate {
    public func editCategory(_ category: ItemCategory?) {
        let editCategoryViewController = EditCategoryViewController(category: category)
        editCategoryViewController.delegate = self
        
        self.present(editCategoryViewController, animated: true, completion: nil)
    }
    
    public func selectCategory(_ category: ItemCategory) {
        delegate?.complete(withCategory: category)
    }
}

extension DisplayCategoriesTableController: CompletableActionDelegate {
    public func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}
