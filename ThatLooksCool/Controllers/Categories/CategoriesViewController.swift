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

class CategoriesViewController: UIViewController {

    struct Constants {
        static let categoryCell = "CategoryCell"
        static let addCell = "AddCell"
    }
    
    weak var delegate: CategorySelectionDelegate?
    
    fileprivate var alertTextField: UITextField?
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    fileprivate var categories = [ItemCategory]()
    
    var canAddCategories = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.view.addSubview(tableView)
        self.view.constrainSubviewToBounds(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.addCell)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: Constants.categoryCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        RealmSubjects.shared.resolvedItemCategoriesSubject
            .subscribe(onNext: { [weak self] (categories: [ItemCategory]) in
                print(categories.count)
                self?.categories = categories
                self?.tableView.reloadData()
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func isAddCategoryRow(_ indexPath: IndexPath) -> Bool {
        return canAddCategories && indexPath.row == categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + (canAddCategories ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isAddCategoryRow(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.addCell, for: indexPath)
            cell.textLabel?.text = "- Add New Category -"
            cell.textLabel?.textAlignment = .center
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell, for: indexPath)
            (cell as? CategoryCell)?.displayCategory(displayable: categories[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isAddCategoryRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(style: .destructive, title: "Remove", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
            guard let self = self else {
                completion(false)
                return
            }
            
            RealmSubjects.shared.removeCategory(self.categories[indexPath.row])
            completion(true)
        })
        
        let edit = UIContextualAction(style: .destructive, title: "Edit", handler: { [weak self] (action, view, completion: @escaping (Bool) -> Void) in
            guard let self = self else {
                completion(false)
                return
            }
            
            self.delegate?.editCategory(self.categories[indexPath.row])
            completion(true)
        })
        
        return UISwipeActionsConfiguration(actions: [edit, remove])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isAddCategoryRow(indexPath) {
            self.delegate?.editCategory(nil)
        } else {
            delegate?.selectCategory(categories[indexPath.row])
        }
    }
}
