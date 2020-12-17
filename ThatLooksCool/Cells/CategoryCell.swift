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

    private let cellDisplayView = CategoryCellView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(cellDisplayView)
        self.contentView.constrainSubviewToBounds(cellDisplayView)
    }
    
    func displayCategory(displayable: CategoryDisplayable) {
        cellDisplayView.displayCategory(displayable: displayable)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
