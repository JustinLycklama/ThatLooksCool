//
//  ResolvedItemsViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import RxSwift

import TLCModel

protocol ItemSelectionDelegate: AnyObject {
    func ediItem(_ item: Item?)
    func selectItem(_ item: Item)
}

class ItemsTableController: AddableSectionTableController {

    struct Constants {
        static let ItemCell = "ItemCell"
    }
    
    private let category: ItemCategory
    private var items = [Item]()
        
    weak var delegate: ItemSelectionDelegate?
    
    let disposeBag = DisposeBag()
        
    init(category: ItemCategory) {
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table
        tableView.register(ItemCell.self, forCellReuseIdentifier: Constants.ItemCell)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.delegate = self
        tableView.dataSource = self
        
        RealmSubjects.shared.resolvedItemSubjectsByCategory[category]?.subscribe(
            onNext: { [weak self] (itemList: [Item]) in
                self?.items = itemList
                self?.tableView.reloadData()
                
        }, onError: { (err: Error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
}

extension ItemsTableController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return canAddNewItem ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canAddNewItem && isAddItemSection(section) {
            return 1
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isAddItemIndex(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: AddableSectionConstants.AddCell, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.ItemCell, for: indexPath)
            (cell as? ItemCell)?.displayItem(displayable: items[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isAddItemIndex(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                    
        let remove = UIContextualAction(style: .destructive, title: "", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
            guard let self = self else {
                completion(false)
                return
            }
            
            RealmSubjects.shared.removeItem(self.items[indexPath.row])
            completion(true)
        })
                
        remove.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        remove.image = ImagesResources.shared.deleteIcon

        return UISwipeActionsConfiguration(actions: [remove])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isAddItemIndex(indexPath) {
            delegate?.ediItem(nil)
        } else {
            delegate?.selectItem(items[indexPath.row])
        }
    }
}

extension ItemsTableController : CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ItemsTableController : ItemSelectionDelegate {
    func ediItem(_ item: Item?) {
        let editView = ItemEditableFieldsViewController(item: item, category: category)
        
        editView.completeDelegate = self
        
        self.present(editView, animated: true, completion: nil)
    }
    
    func selectItem(_ item: Item) {
        ediItem(item)
    }
}


