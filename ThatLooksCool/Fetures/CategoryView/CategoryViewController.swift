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
import RxSwift

class CategoryViewController: AdViewController {
    
    let header: EditCategoryView
    
    // MARK: - Lifecycle
    
    let category: ItemCategory
//    var mockCategory: MockCategory
    
    let disposeBag = DisposeBag()
    
    init(category: ItemCategory?) {
                        
        var pageCategory: ItemCategory! = category
        if pageCategory == nil {
            pageCategory = RealmSubjects.shared.addCategory(withMock: MockCategory(category: nil))
        }
        
        self.category = pageCategory
        header = EditCategoryView(category: pageCategory)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding
        
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(createItemsArea())
                
        self.contentArea.addSubview(stack)
        self.contentArea.constrainSubviewToBounds(stack)
        
        contentArea.addConstraint(.init(item: header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175))

    }
    
    private func createItemsArea() -> UIView {
        let container = UIView()

        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (item: Item) in
            RealmSubjects.shared.removeItem(item)
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: { [weak self] in
            guard let self = self else {
                return
            }
            
            let item = RealmSubjects.shared.createItem(withMock: MockItem(item: nil), toCategory: self.category)
            
            let itemViewController = ItemViewController(item: item)
            itemViewController.modalPresentationStyle = .formSheet  //.overCurrentContext
            itemViewController.delegate = self

            self.present(itemViewController, animated: true, completion: nil)
        })
        
        let itemCellConfig = TableCellConfig(swipeActions: [deleteSwipAction]) { (item: Item, cell: ItemTableViewCell) in
            cell.displayItem(item: item)
            cell.onlyDisplayDate(true)
        } performAction: { [weak self]  (item: Item) in
            guard let self = self else {
                return
            }
            
            let itemViewController = ItemViewController(item: item)
            itemViewController.modalPresentationStyle = .formSheet  //.overCurrentContext
            itemViewController.delegate = self
            
            self.present(itemViewController, animated: true, completion: nil)
        }
        
        let itemTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: itemCellConfig)
        itemTable.canPerformAction = true
                
        container.addSubview(itemTable)
        container.constrainSubviewToBounds(itemTable, onEdges: [.left, .right, .bottom], withInset: UIEdgeInsets(TLCStyle.topPadding))
        container.constrainSubviewToBounds(itemTable, onEdges: [.top])
        
         if let disposable = RealmSubjects.shared.resolvedItemSubjectsByCategory[category]?.subscribe(
            onNext: { (items: [Item]) in
                itemTable.setItems(items: items)
            }, onError: { (error: Error) in
                
            },
            onCompleted: {
                
            },
            onDisposed: {
                
            }) {
            disposeBag.insert(disposable)
         }
        
        return container
    }
}

extension CategoryViewController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}
