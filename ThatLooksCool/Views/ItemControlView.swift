//
//  ItemIterationView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-09.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

protocol ItemIterationDelegate: AnyObject {
    func didPressDelete()
    func didPressNext()
    func didPressUndo()
}

class ItemControlView: ShadowView {

    private let deleteButton = UIButton()
    private let nextButton = UIButton()
    private let undoButton = UIButton()
    
    var canDelete: Bool = false {
        didSet {
            deleteButton.isEnabled = canDelete
        }
    }
    
    var canNext: Bool = false {
        didSet {
            nextButton.isEnabled = canNext
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
        self.backgroundColor = .white
        self.layer.cornerRadius = TLCStyle.cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        let stackView = UIStackView(arrangedSubviews: [deleteButton, undoButton, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

//        previousButton.setTitle("previous", for: .normal)
        
        
        deleteButton.setImage(ImagesResources.shared.deleteIcon, for: .normal)
        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        
        nextButton.setImage(ImagesResources.shared.nextIcon, for: .normal)
        nextButton.addTarget(self, action: #selector(didPressNext), for: .touchUpInside)
        
        undoButton.setImage(ImagesResources.shared.undoIcon, for: .normal)
        undoButton.addTarget(self, action: #selector(didPressUndo), for: .touchUpInside)
        undoButton.addBorder(edges: [.left, .right])
        
        for button in [deleteButton, nextButton, undoButton] {
            button.setTitleColor(.black, for: .disabled)
        }
        
        self.addSubview(stackView)
        self.constrainSubviewToBounds(stackView)
                
        canUndo = false
        canNext = false
    }
    
    @objc
    func didPressDelete() {
        delegate?.didPressDelete()
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
