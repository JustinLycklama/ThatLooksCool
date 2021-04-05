//
//  CategoryCollectionCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-09.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public class CategoryCollectionCell: UICollectionViewCell {
    
//    public static let height: CGFloat = 102
    
    private lazy var cellDisplayView: CategoryWidget = {
        let view = CategoryWidget()
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TLCStyle.categoryWidgetDesiredSize.height))
        
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
