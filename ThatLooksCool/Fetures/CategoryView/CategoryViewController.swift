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

class CategoryViewController: UIViewController {
    
    let header: EditCategoryView
    
    // MARK: - Lifecycle
    
    let category: ItemCategory
    
    let disposeBag = DisposeBag()
    
    weak var delegate: CompletableActionDelegate? {
        didSet {
            header.delegate = delegate
        }
    }
    
    init(category: ItemCategory?) {
                        
        var pageCategory: ItemCategory! = category
        if pageCategory == nil {
            pageCategory = ItemCategory.create(withMock: MockCategory(category: nil))
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
                        
        let content = HeaderContentLayout(header: header, content: createItemsArea(), spacing: TLCStyle.topPadding, headerHeight: 175)
        
        let closeInfoPrint = UILabel()
        closeInfoPrint.style(TextStyle.finePrint)
        closeInfoPrint.text = "Swipe down to close"
        closeInfoPrint.textAlignment = .center

        content.addSubview(closeInfoPrint)
        content.constrainSubviewToBounds(closeInfoPrint, onEdges: [.top, .left, .right], withInset: UIEdgeInsets(TLCStyle.elementPadding))
                
        self.view.addAndConstrainSubview(AdContainerLayout(rootViewController: self, content: content))
    }
    
    private func createItemsArea() -> UIView {
        let container = UIView()

        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (item: Item) in
            item.remove()
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: { [weak self] in
            guard let self = self else {
                return
            }
            
            if let item = Item.create(withMock: MockItem(item: nil), toCategory: self.category) {
                let itemViewController = ItemViewController(item: item)
                itemViewController.modalPresentationStyle = .formSheet  //.overCurrentContext
                itemViewController.delegate = self
                
                self.present(itemViewController, animated: true, completion: nil)
            }
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
        
        
        DatabaseListener.shared.items(by: category) { (observation: DatabaseObservation<Item>) in
            switch observation {
            
            case .initial(let items):
                itemTable.setItems(items: items)
            case .update(let items, _, _, _):
                // TODO:
                itemTable.setItems(items: items)
            case .error(let error):
                print("Error in categories Controller updating items: \(error.localizedDescription)")
            }
        }
        
//         if let disposable = RealmSubjects.shared.resolvedItemSubjectsByCategory[category]?.subscribe(
//            onNext: { (items: [Item]) in
//                itemTable.setItems(items: items)
//            }, onError: { (error: Error) in
//
//            },
//            onCompleted: {
//
//            },
//            onDisposed: {
//
//            }) {
//            disposeBag.insert(disposable)
//         }
        
        return container
    }
}

extension CategoryViewController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}
