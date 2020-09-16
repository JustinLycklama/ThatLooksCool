//
//  TitleContentView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

class TitleContentView: UIView {

    public let titleLabel = UILabel()
    public let contentView = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    
    private func initialize() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        contentView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentView)
        
        addSubview(stackView)
        constrainSubviewToBounds(stackView)
    }
}
