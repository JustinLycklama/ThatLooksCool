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
        
        self.view.clipsToBounds = false
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        let maskingView = UIView()
        maskingView.clipsToBounds = true
                
        self.view.addSubview(maskingView)
        self.view.constrainSubviewToBounds(maskingView, withInset: UIEdgeInsets(top: -TLCStyle.interiorMargin,
                                                                                left: -TLCStyle.interiorMargin,
                                                                                bottom: -TLCStyle.interiorMargin,
                                                                                right: -TLCStyle.interiorMargin))
        
        maskingView.addSubview(tableView)
        maskingView.constrainSubviewToBounds(tableView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                                left: TLCStyle.interiorMargin,
                                                                                bottom: TLCStyle.interiorMargin,
                                                                                right: TLCStyle.interiorMargin))
        
        // Table
        tableView.register(CategoryAddCell.self, forCellReuseIdentifier: Constants.addCell)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: Constants.categoryCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.clipsToBounds = false

        tableView.tableFooterView = UIView()
        
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

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func isAddCategorySection(_ section: Int) -> Bool {
        return section == 0
    }
    
    private func isAddCategoryIndex(_ indexPath: IndexPath) -> Bool {
        return canAddCategories && isAddCategorySection(indexPath.section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return canAddCategories ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canAddCategories && isAddCategorySection(section) {
            return 1
        }
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if isAddCategoryIndex(indexPath) {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.addCell, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell, for: indexPath)
            (cell as? CategoryCell)?.displayCategory(displayable: categories[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if canAddCategories && section == 0 {
            let footer = UIView()
//            footer.addBorder(edges: .top, color: .lightGray, thickness: 1.0)
            return footer
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if canAddCategories && section == 0 {
            return TLCStyle.topLevelPadding
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isAddCategoryIndex(indexPath)
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

        remove.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0)
        edit.backgroundColor = TLCStyle.primaryIconColor.withAlphaComponent(0)
        
        edit.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { ctx in
            ctx.cgContext.setFillColor(TLCStyle.primaryIconColor.cgColor)
            UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate).draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        
        remove.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { ctx in
            ctx.cgContext.setFillColor(TLCStyle.destructiveIconColor.cgColor)
            UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate).draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        
        return UISwipeActionsConfiguration(actions: [edit, remove])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isAddCategoryIndex(indexPath) {
            self.delegate?.editCategory(nil)
        } else {
            delegate?.selectCategory(categories[indexPath.row])
        }
    }
}
