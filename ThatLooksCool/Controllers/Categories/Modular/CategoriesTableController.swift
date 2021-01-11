//
//  ResolvedItemCategoriesTableView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import RxSwift

import TLCModel

protocol CategorySelectionDelegate: AnyObject {
    func editCategory(_ category: ItemCategory?)
    func selectCategory(_ category: ItemCategory)
}

class CategoriesTableController: AddableSectionTableController {

    struct Constants {
        static let categoryCell = "CategoryCell"
    }
    
    weak var delegate: CategorySelectionDelegate?
        
    private let disposeBag = DisposeBag()
    
    fileprivate var categories = [ItemCategory]()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: Constants.categoryCell)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        RealmSubjects.shared.resolvedItemCategoriesSubject
            .subscribe(onNext: { [weak self] (categories: [ItemCategory]) in
                self?.categories = categories
                self?.tableView.reloadData()
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
    }
}

extension CategoriesTableController: UITableViewDataSource, UITableViewDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return canAddNewItem ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canAddNewItem && isAddItemSection(section) {
            return 1
        }
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isAddItemIndex(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: AddableSectionConstants.AddCell, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell, for: indexPath)
            (cell as? CategoryCell)?.displayCategory(displayable: categories[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if canAddNewItem && section == 0 {
            return UIView()
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if canAddNewItem && section == 0 {
            return TLCStyle.topLevelPadding
        }
        
        return 0
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
            
            RealmSubjects.shared.removeCategory(self.categories[indexPath.row])
            completion(true)
        })
                
        remove.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        remove.image = ImagesResources.shared.deleteIcon
        
        let edit = UIContextualAction(style: .destructive, title: "", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
            guard let self = self else {
                completion(false)
                return
            }
            
            self.delegate?.editCategory(self.categories[indexPath.row])
            completion(true)
        })

        edit.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        edit.image = ImagesResources.shared.editIcon
        
        return UISwipeActionsConfiguration(actions: [edit, remove])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isAddItemIndex(indexPath) {
            self.delegate?.editCategory(nil)
        } else {
            delegate?.selectCategory(categories[indexPath.row])
        }
    }
}
