//
//  AddableSectionTableController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-07.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

open class AddableSectionTableController: UIViewController {

    public struct AddableSectionConstants {
        public static let AddCell = "AddCell"
    }
        
    public let tableView = UITableView()
    
    public var canAddNewItem = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    open override func viewDidLoad() {
        super .viewDidLoad()
        
        self.view.clipsToBounds = false
        self.view.layer.cornerRadius = TLCStyle.cornerRadius
        self.view.backgroundColor = .clear
        
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
        tableView.register(AddCell.self, forCellReuseIdentifier: AddableSectionConstants.AddCell)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.clipsToBounds = false

        tableView.tableFooterView = UIView()
    }
    
    public func isAddItemSection(_ section: Int) -> Bool {
        return section == 1 && canAddNewItem
    }
    
    public func isAddItemIndex(_ indexPath: IndexPath) -> Bool {
        return canAddNewItem && isAddItemSection(indexPath.section)
    }
    
}
