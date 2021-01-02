//
//  ItemIterationView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-09.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

protocol ItemIterationDelegate: AnyObject {
    func didPressPrevious()
    func didPressNext()
    func didPressUndo()
}

class ItemControlView: ShadowView {

    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private let undoButton = UIButton()
    
    var canPreviousNext: Bool = false {
        didSet {
            previousButton.isEnabled = canPreviousNext
            nextButton.isEnabled = canPreviousNext
        }
    }
    
    var canUndo: Bool = false {
        didSet {
            undoButton.isEnabled = canUndo
        }
    }
    
    weak var delegate: ItemIterationDelegate?
    
    override init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
//
//        // Defer to hit didSet
//        defer {
//            canUndo = false
//            canPreviousNext = false
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [previousButton, undoButton, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        previousButton.setTitle("previous", for: .normal)
        previousButton.addTarget(self, action: #selector(didPressPrevious), for: .touchUpInside)
        
        nextButton.setTitle("next", for: .normal)
        nextButton.addTarget(self, action: #selector(didPressNext), for: .touchUpInside)
        
        undoButton.setTitle("undo", for: .normal)
        undoButton.addTarget(self, action: #selector(didPressUndo), for: .touchUpInside)

        for button in [previousButton, nextButton, undoButton] {
            button.setTitleColor(.black, for: .disabled)
        }
        
        self.addSubview(stackView)
        self.constrainSubviewToBounds(stackView)
                
        canUndo = false
        canPreviousNext = false
    }
    
    @objc
    func didPressPrevious() {
        delegate?.didPressPrevious()
    }

    @objc
    func didPressNext() {
        delegate?.didPressNext()
    }
    
    @objc
    func didPressUndo() {
        delegate?.didPressUndo()
    }
}
