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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Classic.style.baseBackgroundColor
        
//        self.navigationController?.navigationBar.isHidden = true
        
    
        
        let stack = UIStackView()
        stack.axis = .vertical
//        stack.distribution = .equalSpacing
        
        
        stack.addArrangedSubview(createHeader())
        stack.addArrangedSubview(UIView())

        stack.addArrangedSubview(createCategoriesView())
                
        self.contentView.addSubview(stack)
        self.contentView.constrainSubviewToBounds(stack)
    }
    
    func createHeader() -> UIView {
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//
        headerView.backgroundColor = TLCStyle.headingViewColor
////        headerView.addConstraint(.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
//
        let titleLabel = UILabel()
        titleLabel.style(TextStyle.heading)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

//        titleLabel.text = "\nThat\nLooks Cool"
        let mutableString = NSMutableAttributedString()
//
        let accentTitle = NSAttributedString(string: "\nThat\n",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextAccentColor])
        let titleSuffix = NSAttributedString(string: "Looks Cool",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextColor])

        mutableString.append(accentTitle)
        mutableString.append(titleSuffix)

        titleLabel.attributedText = mutableString
//
        headerView.addSubview(titleLabel)
        headerView.constrainSubviewToBounds(titleLabel, withInset: UIEdgeInsets(TLCStyle.topLevelMargin))

        headerView.setContentHuggingPriority(.required, for: .vertical)
                
        return headerView
    }
    
    func createCategoriesView() -> UIView {
        
        

        let categoryCellConfig = CollectionCellConfig { (category: ItemCategory, cell: CategoryCollectionCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
//            self?.delegate?.complete(withCategory: category)
        }
            
//        let categoriesTable = ActionableTableView(itemConfig: categoryCellConfig)
//        categoriesTable.canPerformAction = true
        
        let categoriesView = ActionableGridView(itemConfig: categoryCellConfig)
        
        
        let cat1 = ItemCategory()
        let cat2 = ItemCategory()
        let cat3 = ItemCategory()
        let cat4 = ItemCategory()
        let cat5 = ItemCategory()
        let cat6 = ItemCategory()
        let cat7 = ItemCategory()



        categoriesView.setItems(items: [cat1, cat2, cat3, cat4, cat5, cat6, cat7])
        
        categoriesView.addConstraint(.init(item: categoriesView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 125))
        
        return categoriesView
    }
}

//// MARK: - CompletableActionDelegate
//extension HomeViewController: CompletableActionDelegate {
//    func complete() {
//        self.dismiss(animated: true) {
//
//        }
//    }
//}
