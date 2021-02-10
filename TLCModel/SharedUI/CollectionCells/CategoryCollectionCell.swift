//
//  CategoryCollectionCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-09.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import Foundation

import UIKit

public class CategoryCollectionCell: UICollectionViewCell {

    private lazy var cellDisplayView: CategoryCollectionCellView = {
        let view = CategoryCollectionCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .clear
        
        self.contentView.clipsToBounds = false
        
        self.contentView.addSubview(cellDisplayView)
        self.contentView.constrainSubviewToBounds(cellDisplayView)
    }
    
    public func displayCategory(displayable: CategoryDisplayable) {
        cellDisplayView.displayCategory(displayable: displayable)
    }
}
