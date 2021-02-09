//
//  DisplayCategoriesTableController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-07.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import RxSwift

import ClassicClient

public protocol CompletableWithCategoryDelegate: AnyObject {
    func complete(withCategory category: ItemCategory?)
}

public class DisplayCategoriesTableController: UIViewController {
    
    public weak var delegate: CompletableWithCategoryDelegate?

    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        edgesForExtendedLayout = []
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
//        let contentView = UIView()
//        contentView.backgroundColor = .clear
        
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
        
//        contentView.addSubview(stack)
//        contentView.constrainSubviewToBounds(stack)
        
        self.view.addSubview(stack)
        self.view.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(TLCStyle.topLevelMargin))
        
        addBackgroundImage()
    }
    
    @objc func close() {
        delegate?.complete(withCategory: nil)
    }
    
    private func createCategoriesView() -> UIView {
                
        func editCategory(category: ItemCategory?) {
            let editCategoryViewController = EditCategoryViewController(category: nil)
            editCategoryViewController.delegate = self
            
            self.present(editCategoryViewController, animated: true, completion: nil)
        }
        
        
        let editSwipeAction = SwipeActionConfig(image: TLCIconSet.edit.image()) { (category: ItemCategory) in
            editCategory(category: category)
        }
        
        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (category: ItemCategory) in
            RealmSubjects.shared.removeCategory(category)
        }
        
        let categoryCellConfig = CellConfig(swipeActions: [editSwipeAction, deleteSwipAction]) { (category: ItemCategory, cell: CategoryCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
            self?.delegate?.complete(withCategory: category)
        }

        
//            itemEdited: { (category: ItemCategory) in
//               editCategory(category: category)
//           } itemDeleted: { (category: ItemCategory) in
//               RealmSubjects.shared.removeCategory(category)
//           }
        
        let actionCellConfig = CellConfig<Void, AddCell> { (_) in
            editCategory(category: nil)
        }
            
        let categoriesTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: categoryCellConfig)
        categoriesTable.canPerformAction = true
        
        RealmSubjects.shared.resolvedItemCategoriesSubject
            .subscribe(onNext: { (categories: [ItemCategory]) in
                categoriesTable.setItems(items: categories)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        return categoriesTable
    }
}

//extension DisplayCategoriesTableController: ActionableTableDelegate {
//    public func performAction() {
//
//        let editCategoryViewController = EditCategoryViewController(category: nil)
//        editCategoryViewController.delegate = self
//
//        self.present(editCategoryViewController, animated: true, completion: nil)
//    }
//
//    public func itemSelected(atIndex indexPath: IndexPath) {
//        if let category = categoriesTable.item(at: indexPath) {
//            delegate?.complete(withCategory: category)
//        }
//    }
//}

extension DisplayCategoriesTableController: CompletableActionDelegate {
    public func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}
