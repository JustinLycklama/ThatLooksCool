//
//  ItemIterationView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-09.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

protocol ItemIterationDelegate: AnyObject {
    func didPressFirst()
    func didPressThird()
    func didPressSecond()
}

class ItemControlView: ShadowView {

    enum ButtonType {
        case one, two, three
    }
    
    private let firstButton = UIButton()
    private let thirdButton = UIButton()
    private let secondButton = UIButton()
    
    private let buttonMap: [ButtonType : UIButton]
    
    var firstButtonEnabled: Bool = false {
        didSet {
            firstButton.isEnabled = firstButtonEnabled
        }
    }
    
    var thirdButtonEnabled: Bool = false {
        didSet {
            thirdButton.isEnabled = thirdButtonEnabled
        }
    }
    
    var secondButtonEnabled: Bool = false {
        didSet {
            secondButton.isEnabled = secondButtonEnabled
        }
    }
    
    weak var delegate: ItemIterationDelegate?
    
    convenience override init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        buttonMap = [.one : firstButton, .two : secondButton, .three : thirdButton]

        super.init(frame: frame)

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = TLCStyle.cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
            
        firstButton.setImage(ImagesResources.shared.deleteIcon, for: .normal)
        firstButton.addTarget(self, action: #selector(didPressFirst), for: .touchUpInside)
        
        thirdButton.setImage(ImagesResources.shared.nextIcon, for: .normal)
        thirdButton.addTarget(self, action: #selector(didPressThird), for: .touchUpInside)
        
        secondButton.setImage(ImagesResources.shared.listIcon, for: .normal)
        secondButton.addTarget(self, action: #selector(didPressSecond), for: .touchUpInside)
        secondButton.addBorder(edges: [.left, .right])
        
        for button in [firstButton, thirdButton, secondButton] {
            button.setTitleColor(.black, for: .disabled)
        }
        
        self.addSubview(stackView)
        self.constrainSubviewToBounds(stackView)
                
        secondButtonEnabled = false
        thirdButtonEnabled = false
    }
    
    internal func setIcon(icon: UIImage, forButton button: ButtonType) {
        buttonMap[button]?.setImage(icon, for: .normal)
    }
    
    @objc
    func didPressFirst() {
        delegate?.didPressFirst()
    }

    
    @objc
    func didPressSecond() {
        delegate?.didPressSecond()
    }
    
    @objc
    func didPressThird() {
        delegate?.didPressThird()
    }
}
