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
    
    private lazy var categoryIcon: UIView = {
        
        let view = UIView()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.heading.size, weight: .light, scale: .default)
        let image = UIImage(systemName: "books.vertical", withConfiguration: imageConfig)?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        
//        let view = CategoryIcon(image: image)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        view.constrainSubviewToBounds(imageView)
//
//        view.addConstraint(.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
//
        view.addConstraint(.init(item: imageView, attribute: .width, relatedBy: .equal,
                                      toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
        
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.label)
        label.textColor = .white

        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.subLabel)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.subLabel)
        label.textAlignment = .right

        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.style(TextStyle.subLabel)
        label.textAlignment = .right
        
        label.text = "12345"
        
        return label
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.addConstraint(.init(item: self, attribute: .height, relatedBy: .equal,
                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                      constant: TLCStyle.categoryImageHeight + TLCStyle.elementMargin * 2))
        
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        
        let accentView = AccentView()
        
        accentView.setPrimaryView(createItemInfoView())
        accentView.setSecondaryView(createMetadataView())
        
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
    
    private func createMetadataView() -> UIView {
        
        let metaStack = UIStackView()
        metaStack.axis = .horizontal
        metaStack.spacing = TLCStyle.elementPadding
        
        // Date Category Label
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalCentering
        
        vStack.addArrangedSubview(categoryLabel)
        vStack.addArrangedSubview(dateLabel)

        metaStack.addArrangedSubview(vStack)
        metaStack.addArrangedSubview(categoryIcon)
        
        return metaStack
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
    }
}
