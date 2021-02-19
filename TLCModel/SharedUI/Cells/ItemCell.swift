//
//  ItemCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-17.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public class ItemCell: UITableViewCell {

    private var cellDisplayView: ItemCellView?
    
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
        
        let cellDisplay = UIView.instanceFromNib("ItemCellView", inBundle: Bundle(for: ItemCellView.self)) as! ItemCellView
        cellDisplayView = cellDisplay

        self.contentView.addSubview(cellDisplay)
        self.contentView.constrainSubviewToBounds(cellDisplay, withInset: UIEdgeInsets(top: TLCStyle.collectionMargin,
                                                                                       left: 0,
                                                                                       bottom: TLCStyle.collectionMargin,
                                                                                       right: 0))
    }
    
    public func displayItem(displayable: ItemDisplayable) {
        cellDisplayView?.displayItem(displayable: displayable)
    }
}
