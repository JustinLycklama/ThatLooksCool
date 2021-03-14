//
//  ItemTableViewCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-27.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public class ItemTableViewCell: UITableViewCell {
    
    private lazy var cellDisplayView: ItemWidget = {
        let view = ItemWidget()
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ItemCollectionCell.height))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        self.contentView.clipsToBounds = false
        
        self.contentView.addSubview(cellDisplayView)
        self.contentView.constrainSubviewToBounds(cellDisplayView)
        self.contentView.constrainSubviewToBounds(cellDisplayView, withInset: UIEdgeInsets(top: 10,
                                                                                           left: 0,
                                                                                           bottom: 10,
                                                                                           right: 0))
    }
    
    public func displayItem(item: Item) {
        cellDisplayView.displayItem(item: item)
    }
}
