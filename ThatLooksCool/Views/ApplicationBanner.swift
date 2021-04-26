//
//  ApplicationHeader.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-25.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

import EasyNotificationBadge

protocol BannerDelegate: AnyObject {
    func settingsPressed()
    func secondaryIconPressed()
}

struct BannerTitleInfo {
    let accentString: String
    let plainString: String
    let textLeftAligned: Bool
}

class ApplicationBanner: UIView {
 
    weak var delegate: BannerDelegate?
    
    private lazy var searchbar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.setImage(TLCIconSet.search.image(), for: .search, state: .normal)
//        bar.backgroundColor = TLCStyle.searchBackgroundColor
        
        let textFieldInsideSearchBar = bar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = TLCStyle.searchBackgroundColor
        
        return bar
    }()
    
    private lazy var settingsIcon: UIView = {
        let button = UIButton(frame: .zero)
        
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        
        if let settingsIcon = TLCIconSet.settings.image() {
            button.setImage(settingsIcon, for: .normal)
        }
        
        return button
    }()
    
    private lazy var backButton: UIView = {
        let button = UIButton(frame: .zero)
        
        button.addTarget(self, action: #selector(secondaryIconPressed), for: .touchUpInside)
        
        if let backIcon = TLCIconSet.back.image()?.withTintColor(TLCStyle.titleTextAccentColor) {
            button.setImage(backIcon, for: .normal)
        }
        
        return button
    }()
    
    private lazy var identifyButton: UIView = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(secondaryIconPressed), for: .touchUpInside)
        
        if let identifyIcon = TLCIconSet.identify.image()?.withTintColor(TLCStyle.titleTextAccentColor) {
            button.setImage(identifyIcon, for: .normal)
        }
        
        let badgePositioner = UIView()
        button.addSubview(badgePositioner)
        button.constrainSubviewToBounds(badgePositioner, onEdges: [.right, .top])
        
        var appearance = BadgeAppearance()
        appearance.duration = 2
        appearance.borderWidth = 1
        appearance.backgroundColor = TLCStyle.titleTextAccentColor
        appearance.allowShadow = true
        appearance.font = UIFont(name: "Avenir-Book", size: 10)!
        
        DatabaseListener.shared.newItems { (observation: DatabaseObservation<Item>) in
            switch observation {
            case .initial(let items), .update(let items, _, _, _):
                let text: String? = (items.count > 0) ? String(items.count) : nil
                badgePositioner.badge(text: text, appearance: appearance)
            case .error(let error):
                error.presentToUser("Failed new item update on Home Controller")
                print("Failed new item update on Home Controller")
            }
        }
        
        return button
    }()
    
    init(titleInfo: BannerTitleInfo, withSearchBarAndNewItems: Bool) {
        super.init(frame: .zero)

        let backgroundView = ShadowView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.layer.cornerRadius = 25
        backgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        backgroundView.backgroundColor = TLCStyle.bannerViewColor

        let stack = UIStackView()
        stack.axis = .vertical
        
        let textIconStack = UIStackView()
        textIconStack.axis = .horizontal
        
        let titleLabel = createTitleLabel(titleInfo: titleInfo)
        let iconsView = createIconsView(useIdentifyButton: withSearchBarAndNewItems)
        
        if titleInfo.textLeftAligned {
            textIconStack.addArrangedSubview(titleLabel)
            textIconStack.addArrangedSubview(iconsView)
        } else {
            textIconStack.addArrangedSubview(iconsView)
            textIconStack.addArrangedSubview(titleLabel)
        }
        
        stack.addArrangedSubview(textIconStack)
        
        if withSearchBarAndNewItems {
            stack.addArrangedSubview(searchbar)
        }

        backgroundView.addSubview(stack)
        
        backgroundView.constrainSubviewToBounds(stack, onEdges: [.top],
                                            withInset: UIEdgeInsets(TLCStyle.topMargin + TLCStyle.safeArea.top))
        backgroundView.constrainSubviewToBounds(stack, onEdges: [.left, .right],
                                            withInset: UIEdgeInsets(TLCStyle.topMargin))
        backgroundView.constrainSubviewToBounds(stack, onEdges: [.bottom],
                                            withInset: UIEdgeInsets(TLCStyle.topPadding))

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        self.addSubview(backgroundView)
        self.constrainSubviewToBounds(backgroundView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTitleLabel(titleInfo: BannerTitleInfo) -> UIView {
        let titleLabel = UILabel()
        titleLabel.style(TextStyle.title)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        let mutableString = NSMutableAttributedString()

        let accentTitle = NSAttributedString(string: "\(titleInfo.accentString)\n",
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextAccentColor])
        let titleSuffix = NSAttributedString(string: titleInfo.plainString,
                                             attributes: [NSAttributedString.Key.foregroundColor : Classic.style.titleTextColor])

        mutableString.append(accentTitle)
        mutableString.append(titleSuffix)

        titleLabel.attributedText = mutableString
        titleLabel.textAlignment = titleInfo.textLeftAligned ? .left : .right
        
        return titleLabel
    }
    
    private func createIconsView(useIdentifyButton: Bool) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        stack.addArrangedSubview(settingsIcon)
        
        if useIdentifyButton {
            stack.addArrangedSubview(identifyButton)
        } else {
            stack.addArrangedSubview(backButton)
        }
        
        stack.addConstraint(.init(item: stack, attribute: .width, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
        return stack
    }
    
    @objc
    func settingsPressed() {
        delegate?.settingsPressed()
    }
    
    @objc
    func secondaryIconPressed() {
        delegate?.secondaryIconPressed()
    }
}
