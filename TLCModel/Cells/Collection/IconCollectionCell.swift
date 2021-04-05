//
//  ImageCollectionViewCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-23.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public class IconCollectionCell: UICollectionViewCell {
    public static let height: CGFloat = 48
    
    public override var isSelected: Bool {
        didSet {
            cellDisplayView.backgroundColor = isSelected ? TLCStyle.accentColor : .white
//            alpha = isSelected ? 0.5 : 1.0
        }
    }
    
    private lazy var cellDisplayView: CategoryIcon = {
        let view = CategoryIcon()
        
        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: IconCollectionCell.height))
        
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
    
    public func setImage(_ image: UIImage?) {
        cellDisplayView.image = image
    }    
}
