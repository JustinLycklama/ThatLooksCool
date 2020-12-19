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

class ItemsViewController: UIViewController {

    struct Constants {
        static let ItemCell = "ItemCell"
        static let AddCell = "AddCell"
    }
    
    private let category: ItemCategory

    private var items = [Item]()
    private let tableView = UITableView()
        
    weak var delegate: ItemSelectionDelegate?
    
    let disposeBag = DisposeBag()
        
    var canAddItems = true {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(category: ItemCategory) {
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        
        self.view.addSubview(tableView)
        self.view.constrainSubviewToBounds(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.AddCell)
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: Constants.ItemCell)
        
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

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    private func isAddItemRow(_ indexPath: IndexPath) -> Bool {
        return canAddItems && indexPath.row == items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + (canAddItems ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isAddItemRow(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.AddCell, for: indexPath)
            cell.textLabel?.text = "Add New Item"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.ItemCell, for: indexPath)
            (cell as? ItemCell)?.displayItem(items[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isAddItemRow(indexPath) {
            delegate?.ediItem(nil)
        } else {
            delegate?.selectItem(items[indexPath.row])
        }
    }
}

extension ItemsViewController : CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ItemsViewController : ItemSelectionDelegate {
    func ediItem(_ item: Item?) {
        let editView = EditItemViewController(item: item, category: category)
        
        editView.completeDelegate = self
        
//        editView.delegate = self
//        editView.modalPresentationStyle = .overFullScreen
        
        self.present(editView, animated: true, completion: nil)
    }
    
    func selectItem(_ item: Item) {
        ediItem(item)
    }
}
