//
//  NewHomeViewController.swift
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

class NewHomeViewController: AdViewController {

    private let disposeBag = DisposeBag()

    private lazy var searchbar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.setImage(TLCIconSet.search.image(), for: .search, state: .normal)
        
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
        label.style(TextStyle.heading)
        
        label.text = "Categories"
        label.setContentHuggingPriority(.required, for: .vertical)

        
        container.addSubview(label)
        container.constrainSubviewToBounds(label, onEdges: [.top, .bottom])
        container.constrainSubviewToBounds(label, onEdges: [.left, .right], withInset: UIEdgeInsets(Classic.style.topPadding))
        
        return container
    }()
    
    private lazy var categoriesView: UIView = {
        
        let container = UIView()

        let categoryCellConfig = CollectionCellConfig { (category: ItemCategory, cell: CategoryCollectionCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
            
            let categoryViewController = CategoryViewController()
            
            self?.present(categoryViewController, animated: true, completion: nil)
            
//            self?.delegate?.complete(withCategory: category)
        }
            
//        let categoriesTable = ActionableTableView(itemConfig: categoryCellConfig)
//        categoriesTable.canPerformAction = true
        
        let gridView = ActionableGridView(itemConfig: categoryCellConfig)
        
        
        let cat1 = ItemCategory()
        let cat2 = ItemCategory()
        let cat3 = ItemCategory()
        let cat4 = ItemCategory()
        let cat5 = ItemCategory()
        let cat6 = ItemCategory()
        let cat7 = ItemCategory()



        gridView.setItems(items: [cat1, cat2, cat3, cat4, cat5, cat6, cat7])
        
        gridView.addConstraint(.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 102))
        
        container.addSubview(gridView)
        container.constrainSubviewToBounds(gridView, onEdges: [.top, .right, .bottom])
        container.constrainSubviewToBounds(gridView, onEdges: [.left], withInset: UIEdgeInsets(Classic.style.topMargin))
        
        return container
    }()
    
    private lazy var itemsHeader: UIView = {
        let container = UIView()
        
        let label = UILabel()
        label.style(TextStyle.heading)
        
        label.text = "Recent Items"
        label.setContentHuggingPriority(.required, for: .vertical)
        
        container.addSubview(label)
        container.constrainSubviewToBounds(label, onEdges: [.top, .bottom])
        container.constrainSubviewToBounds(label, onEdges: [.left, .right], withInset: UIEdgeInsets(Classic.style.topPadding))
        
        return container
    }()
    
    private lazy var itemsView: UIView = {
        
        let container = UIView()

//        let editSwipeAction = SwipeActionConfig(image: TLCIconSet.edit.image()) { (category: ItemCategory) in
//            editCategory(category: category)
//        }
        
        let deleteSwipAction = SwipeActionConfig(image: TLCIconSet.delete.image()) { (item: Item) in
            RealmSubjects.shared.removeItem(item)
        }
                
        let actionCellConfig = TableCellConfig<Void, AddCell> (performAction: nil)
        
        let itemCellConfig = TableCellConfig(swipeActions: [deleteSwipAction]) { (item: Item, cell: ItemTableViewCell) in
            cell.displayItem(item: item)
        } performAction: { [weak self]  (item: Item) in
//            self?.delegate?.complete(withCategory: category)
        }
        
        let itemTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: itemCellConfig)
        
        let cat = ItemCategory()
        cat.title = "Books"
        
        let cat1 = Item(title: "1")
        let cat2 = Item(title: "The Expanse")
        cat2.updateCategory(cat)
        cat2.info = "A sci fi show"
        let cat3 = Item(title: "3")
        let cat4 = Item(title: "4")
        let cat5 = Item(title: "5")
        let cat6 = Item(title: "6")
        let cat7 = Item(title: "7")

        itemTable.setItems(items: [cat1, cat2, cat3, cat4, cat5, cat6, cat7])
        
//        gridView.setContentHuggingPriority(.defaultLow, for: .vertical)
//        gridView.setContentCompressionResistancePriority(.required, for: .vertical)
        
//        gridView.addConstraint(.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
        container.addSubview(itemTable)
        container.constrainSubviewToBounds(itemTable, onEdges: [.left, .right], withInset: UIEdgeInsets(TLCStyle.topMargin))
        container.constrainSubviewToBounds(itemTable, onEdges: [.top, .bottom])

//        container.constrainSubviewToBounds(itemTable, onEdges: [.left], withInset: UIEdgeInsets(Classic.style.topMargin))
//
//        let doubleItemHeight = NSLayoutConstraint.init(item: itemTable, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (ItemCollectionCell.height * 2 + TLCStyle.topPadding * 1))
//        doubleItemHeight.priority = UILayoutPriority(rawValue: 699)

//
//        let tripleItemHeight = NSLayoutConstraint.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (ItemCollectionCell.height * 3 + TLCStyle.topPadding * 2))
//        tripleItemHeight.priority = UILayoutPriority(rawValue: 700)
        
//        itemTable.addConstraint(doubleItemHeight)
////        gridView.addConstraint(tripleItemHeight)
//
//        container.addConstraint(.init(item: itemTable, attribute: .bottom, relatedBy: .lessThanOrEqual,
//                                      toItem: container, attribute: .bottom, multiplier: 1, constant: 0))
        
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
