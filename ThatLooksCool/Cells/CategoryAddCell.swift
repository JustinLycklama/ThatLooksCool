//
//  CategoryAddCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class CategoryAddCell: UITableViewCell {
    
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
                
        let addView = CategoryAddCellView()
        
        self.contentView.addSubview(addView)
        self.contentView.constrainSubviewToBounds(addView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                                      left: TLCStyle.topLevelMargin,
                                                                                      bottom: TLCStyle.interiorMargin,
                                                                                      right: TLCStyle.topLevelMargin))
    }
}
