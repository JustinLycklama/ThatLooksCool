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
    
    private lazy var viewBanner: UIView = {
        let headerView = ShadowView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        headerView.backgroundColor = TLCStyle.bannerViewColor

        let titleLabel = UILabel()
        titleLabel.style(TextStyle.title)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        let mutableString = NSMutableAttributedString()

        let accentTitle = NSAttributedString(string: "\nThat\n",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextAccentColor])
        let titleSuffix = NSAttributedString(string: "Looks Cool",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextColor])

        mutableString.append(accentTitle)
        mutableString.append(titleSuffix)

        titleLabel.attributedText = mutableString

        headerView.addSubview(titleLabel)
        headerView.constrainSubviewToBounds(titleLabel,
                                            withInset: UIEdgeInsets(TLCStyle.topMargin))

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
//        headerView.setContentHuggingPriority(.required, for: .vertical)
        
        return headerView
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
        
        gridView.addConstraint(.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
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

        let categoryCellConfig = CollectionCellConfig { (category: ItemCategory, cell: ItemCollectionCell) in
//            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
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
        
//        gridView.setContentHuggingPriority(.defaultLow, for: .vertical)
//        gridView.setContentCompressionResistancePriority(.required, for: .vertical)
        
//        gridView.addConstraint(.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
        container.addSubview(gridView)
        container.constrainSubviewToBounds(gridView, onEdges: [.top, .right])
        container.constrainSubviewToBounds(gridView, onEdges: [.left], withInset: UIEdgeInsets(Classic.style.topMargin))
        
        let doubleItemHeight = NSLayoutConstraint.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (ItemCollectionCell.height * 2 + TLCStyle.topPadding * 1))
        doubleItemHeight.priority = UILayoutPriority(rawValue: 699)

//
//        let tripleItemHeight = NSLayoutConstraint.init(item: gridView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (ItemCollectionCell.height * 3 + TLCStyle.topPadding * 2))
//        tripleItemHeight.priority = UILayoutPriority(rawValue: 700)
        
        gridView.addConstraint(doubleItemHeight)
//        gridView.addConstraint(tripleItemHeight)
        
        container.addConstraint(.init(item: gridView, attribute: .bottom, relatedBy: .lessThanOrEqual,
                                      toItem: container, attribute: .bottom, multiplier: 1, constant: 0))
        
        return container
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Classic.style.baseBackgroundColor
        
//        self.navigationController?.navigationBar.isHidden = true
        
        
        
        self.contentArea.addSubview(viewBanner)
        self.contentArea.constrainSubviewToBounds(viewBanner, onEdges: [.top, .left, .right])

        
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Classic.style.topPadding
        
//        stack.addArrangedSubview(viewBanner)

        stack.addArrangedSubview(categoriesHeader)
        stack.addArrangedSubview(categoriesView)
                
        stack.addArrangedSubview(itemsHeader)
        stack.addArrangedSubview(itemsView)
        
//        stack.addArrangedSubview(UIView())

        self.contentArea.addSubview(stack)
        self.contentArea.constrainSubviewToBounds(stack, onEdges: [.left, .right])
        
        
        self.contentArea.constrainSubviewToBounds(stack, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.topMargin))
        
        self.contentArea.addConstraint(.init(item: viewBanner, attribute: .bottom, relatedBy: .equal, toItem: stack, attribute: .top, multiplier: 1, constant: -Classic.style.topMargin))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}
