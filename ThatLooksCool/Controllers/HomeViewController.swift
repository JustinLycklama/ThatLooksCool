//
//  HomeViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-02-08.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

import TLCIntents
import TLCModel

import RealmSwift
import RxSwift

import Onboard

class HomeViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private lazy var categoriesHeader: UIView = {
        let container = UIView()
        
        let label = UILabel()
        label.style(TextStyle.header)
        
        label.text = "Categories"
        label.setContentHuggingPriority(.required, for: .vertical)

        
        container.addSubview(label)
        container.constrainSubviewToBounds(label, onEdges: [.top, .bottom])
        container.constrainSubviewToBounds(label, onEdges: [.left, .right], withInset: UIEdgeInsets(Classic.style.topPadding))
        
        return container
    }()
    
    private lazy var categoriesView: UIView = {
        
        let container = UIView()

        let actionCellConfig = CollectionCellConfig<Void, AddCategoryCollectionCell> (swipeActions: []) { (_, cell: AddCategoryCollectionCell) in
        } performAction: { [weak self] (_) in
            let categoryViewController = CategoryViewController(category: nil)
            categoryViewController.delegate = self
            
            self?.present(categoryViewController, animated: true, completion: nil)
        }
        
        let categoryCellConfig = CollectionCellConfig { (category: ItemCategory, cell: CategoryCollectionCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
            let categoryViewController = CategoryViewController(category: category)
            categoryViewController.delegate = self
            
            self?.present(categoryViewController, animated: true, completion: nil)
        }
                    
        let gridView = ActionableGridView(actionConfig: actionCellConfig, itemConfig: categoryCellConfig, itemWidth: TLCStyle.categoryWidgetDesiredSize.width)
        
        gridView.canPerformAction = true
        
        gridView.addConstraint(.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TLCStyle.categoryWidgetDesiredSize.height))
        
        container.addSubview(gridView)
        container.constrainSubviewToBounds(gridView, onEdges: [.top, .right, .bottom])
        container.constrainSubviewToBounds(gridView, onEdges: [.left], withInset: UIEdgeInsets(Classic.style.topMargin))
        
        RealmSubjects.shared.resolvedItemCategoriesSubject
            .subscribe(onNext: { (categories: [ItemCategory]) in
                gridView.setItems(items: categories)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        return container
    }()
    
    private lazy var itemsHeader: UIView = {
        let container = UIView()
        
        let label = UILabel()
        label.style(TextStyle.header)
        
        label.text = "Recent Items"
        label.setContentHuggingPriority(.required, for: .vertical)
        
        container.addSubview(label)
        container.constrainSubviewToBounds(label, onEdges: [.top, .bottom])
        container.constrainSubviewToBounds(label, onEdges: [.left, .right], withInset: UIEdgeInsets(Classic.style.topPadding))
        
        return container
    }()
    
    private lazy var itemsView: UIView = {
        
        let container = UIView()

        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (item: Item) in
            item.remove()
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: nil)
        
        let itemCellConfig = TableCellConfig(swipeActions: [deleteSwipAction]) { (item: Item, cell: ItemTableViewCell) in
            cell.displayItem(item: item)
        } performAction: { [weak self]  (item: Item) in
            let itemViewController = ItemViewController(item: item)
            itemViewController.delegate = self
            self?.present(itemViewController, animated: true, completion: nil)
        }
        
        let itemTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: itemCellConfig)
        
        container.addSubview(itemTable)
        container.constrainSubviewToBounds(itemTable, onEdges: [.left, .right], withInset: UIEdgeInsets(TLCStyle.topMargin))
        container.constrainSubviewToBounds(itemTable, onEdges: [.top, .bottom])

        RealmSubjects.shared.recentlyResolvedItems.subscribe { (items: [Item]) in
            itemTable.setItems(items: items)
        } onError: { (error: Error) in
            
        } onCompleted: {
        
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        return container
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Classic.style.baseBackgroundColor
                
        let banner = ApplicationBanner(titleInfo: BannerTitleInfo(accentString: "That", plainString: "Looks Cool", textLeftAligned: true),
                                       withSearchBarAndNewItems: true)
        banner.delegate = self
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Classic.style.topPadding
        
        stack.addArrangedSubview(categoriesHeader)
        stack.addArrangedSubview(categoriesView)
                
        stack.addArrangedSubview(itemsHeader)
        stack.addArrangedSubview(itemsView)
                
        self.view.addAndConstrainSubview(AdContainerLayout(rootViewController: self,
                                                         content: HeaderContentLayout(header: banner, content: stack, spacing: Classic.style.topMargin)))
    }
    
//    @objc
//    func navigateToNewItems() {
//        let newItemsVC = NewItemsViewController()
//        self.navigationController?.pushViewController(newItemsVC, animated: true)
//    }
}

extension HomeViewController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: BannerDelegate {
    func settingsPressed() {
        
    }
    
    func secondaryIconPressed() {
        let newItemsVC = NewItemsViewController()
        self.navigationController?.pushViewController(newItemsVC, animated: true)
    }
}
