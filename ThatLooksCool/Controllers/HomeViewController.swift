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

class HomeViewController: AdViewController {

    private let disposeBag = DisposeBag()

    private lazy var searchbar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.setImage(TLCIconSet.search.image(), for: .search, state: .normal)
//        bar.backgroundColor = TLCStyle.searchBackgroundColor
        
        let textFieldInsideSearchBar = bar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = TLCStyle.searchBackgroundColor
        
        return bar
    }()
    
    private lazy var viewBanner: UIView = {
        let headerView = ShadowView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        headerView.backgroundColor = TLCStyle.bannerViewColor

        let stack = UIStackView()
        stack.axis = .vertical
//        stack.spacing = TLCStyle.elementPadding
        
        let hstack = UIStackView()
        hstack.axis = .horizontal
        
        let titleLabel = UILabel()
        titleLabel.style(TextStyle.title)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        let mutableString = NSMutableAttributedString()

        let accentTitle = NSAttributedString(string: "That\n",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextAccentColor])
        let titleSuffix = NSAttributedString(string: "Looks Cool",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextColor])

        mutableString.append(accentTitle)
        mutableString.append(titleSuffix)

        titleLabel.attributedText = mutableString
        
        hstack.addArrangedSubview(titleLabel)
        hstack.addArrangedSubview(iconsView)
        
        stack.addArrangedSubview(hstack)
        stack.addArrangedSubview(searchbar)

        headerView.addSubview(stack)
        
        headerView.constrainSubviewToBounds(stack, onEdges: [.top],
                                            withInset: UIEdgeInsets(TLCStyle.topMargin + TLCStyle.safeArea.top))
        headerView.constrainSubviewToBounds(stack, onEdges: [.left, .right],
                                            withInset: UIEdgeInsets(TLCStyle.topMargin))
        headerView.constrainSubviewToBounds(stack, onEdges: [.bottom],
                                            withInset: UIEdgeInsets(TLCStyle.topPadding))

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
//        headerView.setContentHuggingPriority(.required, for: .vertical)
        
        return headerView
    }()
    
    private lazy var iconsView: UIView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        let settingsButton = UIButton(frame: .zero)
        
        if let settingsIcons = TLCIconSet.settings.image() {
            settingsButton.setImage(settingsIcons, for: .normal)
            stack.addArrangedSubview(settingsButton)
        }
        
        let identifyButton = UIButton(frame: .zero)
        
        if let identifyIcon = TLCIconSet.identify.image()?.withTintColor(TLCStyle.titleTextAccentColor) {
            identifyButton.setImage(identifyIcon, for: .normal)
            stack.addArrangedSubview(identifyButton)
        }
        
        stack.addConstraint(.init(item: stack, attribute: .width, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
        return stack
    }()
    
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
            self?.present(categoryViewController, animated: true, completion: nil)
        }
        
        let categoryCellConfig = CollectionCellConfig { (category: ItemCategory, cell: CategoryCollectionCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
            let categoryViewController = CategoryViewController(category: category)
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
            RealmSubjects.shared.removeItem(item)
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: nil)
        
        let itemCellConfig = TableCellConfig(swipeActions: [deleteSwipAction]) { (item: Item, cell: ItemTableViewCell) in
            cell.displayItem(item: item)
        } performAction: { [weak self]  (item: Item) in
            let itemViewController = ItemViewController(item: item)
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
        
        self.contentArea.addSubview(viewBanner)
        self.contentArea.constrainSubviewToBounds(viewBanner, onEdges: [.top, .left, .right])

        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Classic.style.topPadding
        
        stack.addArrangedSubview(categoriesHeader)
        stack.addArrangedSubview(categoriesView)
                
        stack.addArrangedSubview(itemsHeader)
        stack.addArrangedSubview(itemsView)
        
        self.contentArea.addSubview(stack)
        self.contentArea.constrainSubviewToBounds(stack, onEdges: [.left, .right])
        
        self.contentArea.constrainSubviewToBounds(stack, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.topMargin))
        
        self.contentArea.addConstraint(.init(item: viewBanner, attribute: .bottom, relatedBy: .equal, toItem: stack, attribute: .top, multiplier: 1, constant: -Classic.style.topMargin))
    }
}
