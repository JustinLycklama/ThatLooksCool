//
//  CategoryAddCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-01.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public class AddCell: UITableViewCell {
    
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
                
        let addView = AddCellView()
        
        self.contentView.addSubview(addView)
        self.contentView.constrainSubviewToBounds(addView, withInset: UIEdgeInsets(top: TLCStyle.collectionMargin,
                                                                                      left: TLCStyle.topMargin,
                                                                                      bottom: TLCStyle.collectionMargin,
                                                                                      right: TLCStyle.topMargin))
    }
}
