//
//  CategoryCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class CategoryCell: UITableViewCell {

    private var cellDisplayView: CategoryCellView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        self.contentView.clipsToBounds = false
        
        let cellDisplay = UIView.instanceFromNib("CategoryCellView", inBundle: Bundle.main) as! CategoryCellView
        cellDisplayView = cellDisplay
        

        self.contentView.addSubview(cellDisplay)
        self.contentView.constrainSubviewToBounds(cellDisplay, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                                       left: 0,
                                                                                       bottom: TLCStyle.interiorMargin,
                                                                                       right: 0))
    }
    
    func displayCategory(displayable: CategoryDisplayable) {
        cellDisplayView?.displayCategory(displayable: displayable)
    }
}
