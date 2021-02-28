//
//  ImageCollectionViewCell.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-23.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

public class IconCollectionCell: UICollectionViewCell {
    public static let height: CGFloat = 32
    
    private lazy var cellDisplayView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(.init(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
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
