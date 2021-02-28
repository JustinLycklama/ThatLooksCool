//
//  ItemWidget.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2021-02-18.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit

class ItemWidget: UIView {
    private lazy var mapView: UIView =  {
        let view = UIView()
        
//        view.addConstraint(.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24))
//        view.addConstraint(.init(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 3, constant: 0))

        view.backgroundColor = .blue
        
        return view
    }()
    
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
    
    private lazy var textArea: UIView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(detailLabel)

        return vStack
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
    
    private lazy var metaArea: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        vStack.addArrangedSubview(categoryLabel)
        vStack.addArrangedSubview(dateLabel)

        //
//        vStack.addConstraint(.init(item: vStack, attribute: .width, relatedBy: .equal,
//                                   toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
        return vStack
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
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.addConstraint(.init(item: self, attribute: .height, relatedBy: .equal,
                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                      constant: TLCStyle.categoryImageHeight + TLCStyle.elementMargin * 2))
        
        self.layer.cornerRadius = TLCStyle.cornerRadius
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.spacing = TLCStyle.elementPadding
        
        
        
        let accentView = ShadowView()
        
        accentView.backgroundColor = TLCStyle.itemBackgroundColor
        accentView.layer.cornerRadius = TLCStyle.cornerRadius
        
        accentView.addSubview(textArea)
        accentView.constrainSubviewToBounds(textArea, onEdges: [.top, .left, .bottom], withInset: UIEdgeInsets(TLCStyle.elementMargin))
        accentView.constrainSubviewToBounds(textArea, onEdges: [.right], withInset: UIEdgeInsets(TLCStyle.elementPadding))
  
        let metaView = UIView()
        let metaStack = UIStackView()
        metaStack.axis = .horizontal
        metaStack.spacing = TLCStyle.elementPadding
        
        metaStack.addArrangedSubview(metaArea)
        metaStack.addArrangedSubview(categoryIcon)

        metaView.addSubview(metaStack)
        metaView.constrainSubviewToBounds(metaStack, onEdges: [.top, .right, .bottom], withInset: UIEdgeInsets(TLCStyle.elementMargin))
        metaView.constrainSubviewToBounds(metaStack, onEdges: [.left], withInset: UIEdgeInsets(TLCStyle.elementPadding))

        
        hStack.addArrangedSubview(accentView)
        hStack.addArrangedSubview(metaView)
        
        self.addSubview(hStack)
        self.constrainSubviewToBounds(hStack)
    }
    
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
