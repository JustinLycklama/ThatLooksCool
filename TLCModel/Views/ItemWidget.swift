//
//  ItemWidget.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class ItemWidget: UIView {

    // MARK: - properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.itemTitleStyle)
        label.textColor = .white

        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.itemDetailStyle)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.itemDetailStyle)
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.itemDetailStyle)
        label.textAlignment = .right
                
        return label
    }()
    
    private lazy var categoryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.addConstraint(.init(item: imageView, attribute: .width, relatedBy: .equal,
                                      toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
        
        return imageView
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        
//        self.addConstraint(.init(item: self, attribute: .height, relatedBy: .equal,
//                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1,
//                                      constant: 32 + TLCStyle.elementMargin * 2))
        
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        
        let accentView = AccentView()
        
        accentView.setPrimaryView(createItemInfoView())
        accentView.setSecondaryView(metaDataStack)
        
        setupMetaDataStack()
        
        self.addSubview(accentView)
        self.constrainSubviewToBounds(accentView)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
    private func createItemInfoView() -> UIView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(detailLabel)

        return vStack
    }
    
    private lazy var metaDataStack: UIStackView = {
        let metaStack = UIStackView()
        metaStack.axis = .horizontal
        metaStack.spacing = TLCStyle.elementPadding
        
        return metaStack
    }()
    
    private lazy var dateCategoryStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalCentering
        
        return vStack
    }()
    
    public var onlyDisplayData = false {
        didSet {
            setupMetaDataStack()
        }
    }
    
    private func setupMetaDataStack() {
        dateCategoryStack.removeAllArrangedSubviews()
        metaDataStack.removeAllArrangedSubviews()
        
        metaDataStack.addArrangedSubview(dateCategoryStack)
        
        if !onlyDisplayData {
            dateCategoryStack.addArrangedSubview(categoryLabel)
            metaDataStack.addArrangedSubview(categoryIcon)
        }

        dateCategoryStack.addArrangedSubview(dateLabel)
    }
    
    // MARK: - Public
    
    public func displayItem(item: Item) {
        titleLabel.text = item.title
        detailLabel.text = "\t\(item.info ?? "")"
        
        detailLabel.isHidden = item.info == nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d E, MMM"
        
        if let timestamp = item.timestamp {
            dateLabel.text = dateFormatter.string(from: timestamp)
        }
        
        categoryLabel.text = item.category?.title
        categoryIcon.image = item.category?.icon.image()
    }
}
