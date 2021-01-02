//
//  CategorizeUnresolvedViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import RxSwift

import TLCModel
import ClassicClient

struct DisplayItemAndView {
    let displayItem: Item
    let displayController: EditItemViewController
}

class CategorizePendingItemsViewController: AdViewController {

    private let categoriesViewController = CategoriesViewController()

    private let itemDisplayAndNavigationView = UIView()
    private let trippleItemDisplayView = TrippleItemZAzisView()
    
//    private let displayControllerArea = UIView()
    private let itemControlView = ItemControlView()
    private var currentDisplayItemAndView: DisplayItemAndView? = nil
    
    private var disposeBag = DisposeBag()
    
    var currentItem: Item? {
        if let index = currentItemIndex {
            return items[index]
        }
        
        return nil
    }
    
    var currentItemIndex: Int? {
        didSet {
            updateItemDisplay()
        }
    }
    
    var lastResolvedItem: Item? = nil {
        didSet {
            itemControlView.canUndo = lastResolvedItem != nil
        }
    }
    
    var _tempItem: Item?
    var items: [Item] = [] {
        willSet {
            if let item = currentItem {
                _tempItem = item
            }
            
            currentItemIndex = nil
        }
        
        didSet {
            trippleItemDisplayView.badge(text: String(items.count))
            
            let defaultIndex: Int? = items.count > 0 ? 0 : nil
            
            if let item = _tempItem {
                currentItemIndex = items.firstIndex(of: item) ?? defaultIndex
                _tempItem = nil
            } else {
                currentItemIndex = defaultIndex
            }
            
            itemControlView.canPreviousNext = items.count > 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categorize New Items"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        // Categories
        categoriesViewController.canAddCategories = true
        categoriesViewController.delegate = self
        
        let categoriesView = categoriesViewController.view ?? UIView()
        categoriesView.setContentHuggingPriority(.defaultLow, for: .vertical)

        categoriesView.layer.cornerRadius = 10
        categoriesView.layer.isOpaque = false
                
        // Item Display

        let itemViewStack = UIStackView()
        itemViewStack.axis = .vertical
        itemViewStack.spacing = -TLCStyle.interiorPadding


        itemDisplayAndNavigationView.layer.cornerRadius = TLCStyle.cornerRadius
        itemDisplayAndNavigationView.backgroundColor = .clear //TLCStyle.secondaryBackgroundColor
        itemDisplayAndNavigationView.setContentHuggingPriority(.required, for: .vertical)
        itemDisplayAndNavigationView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        setupItemDisplay()
        
        itemDisplayAndNavigationView.addSubview(itemViewStack)
        itemDisplayAndNavigationView.constrainSubviewToBounds(itemViewStack)

        itemViewStack.addArrangedSubview(trippleItemDisplayView)
        itemViewStack.addArrangedSubview(itemControlView)
        
        
        // Item Navigation
        itemControlView.delegate = self
        itemControlView.translatesAutoresizingMaskIntoConstraints = false

        itemControlView.backgroundColor = .white
        itemControlView.layer.cornerRadius = TLCStyle.cornerRadius
        itemControlView.layer.borderWidth = 1
        itemControlView.layer.borderColor = TLCStyle.darkBorderColor.cgColor
        
        itemControlView.shadowType = .border(radius: 10, offset: CGSize(width: 5, height: 5))
        
        itemControlView.addConstraint(NSLayoutConstraint.init(item: itemControlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))
        
        // Stack Setup
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = TLCStyle.topLevelPadding + TLCStyle.interiorPadding
                        
        stackView.addArrangedSubview(itemDisplayAndNavigationView)
        stackView.addArrangedSubview(categoriesView)
        
        contentView.addSubview(stackView)
        contentView.constrainSubviewToBounds(stackView, withInset: UIEdgeInsets(top: TLCStyle.topLevelMargin, left: 0, bottom: 0, right: 0))
        
        
        // Reactive
        RealmSubjects.shared.pendingItemsSubject.subscribe(onNext: { [weak self] (pendingItems: [Item]) in
                self?.items = pendingItems
        }, onError: { (err: Error) in

        }, onCompleted: {

        }) {

        }.disposed(by: disposeBag)
        
        RealmSubjects.shared.removeAllPendingItems()
        RealmSubjects.shared.addPendingItem(title: "1")
        RealmSubjects.shared.addPendingItem(title: "2\nasd asd asd\nasd ads")
        RealmSubjects.shared.addPendingItem()
    }
        
    private func setupItemDisplay() {
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var isAnimatingOut: Bool = false
    private func updateItemDisplay() {
        let duration: TimeInterval = 0.33
        
//        var createItemBlock: (() -> Void)? = nil
        
        guard currentItem != currentDisplayItemAndView?.displayItem else {
            return
        }
        
        let createItemBlock = { [weak self] in
                        
            if let currentItem = self?.currentItem {
                let newDisplayController = EditItemViewController(item: currentItem, category: nil)
                let newDisplayView = newDisplayController.view!
                
                newDisplayView.alpha = 0
                newDisplayView.setContentHuggingPriority(.required, for: .vertical)
                
                newDisplayView.clipsToBounds = true
                newDisplayView.layer.cornerRadius = 10
                newDisplayView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                                
                newDisplayView.addConstraint(NSLayoutConstraint.init(item: newDisplayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250))
                
//                newDisplayView.roundCorners(corners: [.topLeft, .topRight], radius: TLCStyle.cornerRadius)
                
                self?.currentDisplayItemAndView = DisplayItemAndView(displayItem: currentItem, displayController: newDisplayController)
                
                self?.addChild(newDisplayController)
                self?.trippleItemDisplayView.itemDisplayArea.addSubview(newDisplayView)
                self?.trippleItemDisplayView.itemDisplayArea.constrainSubviewToBounds(newDisplayView)
                
                // Grow view to fit constraints
                UIView.animate(withDuration: 0.15) {
                    self?.view.layoutIfNeeded()
                } completion: { _ in
                    // Then make view visible
                    UIView.animate(withDuration: duration) {
                        newDisplayView.alpha = 1
                    }
                }

            } else {
                // Grow to fit no view
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }
        }

        if let oldDisplayItemAndView = currentDisplayItemAndView {

            if !isAnimatingOut {
                isAnimatingOut = true
                
                UIView.animate(withDuration: 0.20, animations: {
                    oldDisplayItemAndView.displayController.view.alpha = 0
                    
                }, completion: { [weak self] _ in
                    oldDisplayItemAndView.displayController.removeFromParent()
                    oldDisplayItemAndView.displayController.view.removeFromSuperview()

                    self?.isAnimatingOut = false
                    self?.currentDisplayItemAndView = nil
                    
                    createItemBlock()
                })
            }
        } else {
            createItemBlock()
        }
    }
}

extension CategorizePendingItemsViewController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategorizePendingItemsViewController: CategorySelectionDelegate {
    func editCategory(_ category: ItemCategory?) {
        let editView = EditCategoryViewController(category: category)

        editView.delegate = self
        editView.modalPresentationStyle = .overFullScreen
        
        self.present(editView, animated: true, completion: nil)
    }
    
    func selectCategory(_ category: ItemCategory) {
        if let currentEditItemController = currentDisplayItemAndView?.displayController {
            RealmSubjects.shared.categorizeItem(currentEditItemController.saveItem(), toCategory: category)
        }
    }
}

extension CategorizePendingItemsViewController: ItemIterationDelegate {
    func didPressPrevious() {
        guard let currentIndex = currentItemIndex else {
            return
        }
        
        if currentIndex > 0 {
            currentItemIndex = currentIndex - 1
        } else {
            currentItemIndex = items.count - 1
        }
    }
    
    func didPressNext() {
        guard let currentIndex = currentItemIndex else {
            return
        }
        
        if currentIndex < items.count - 1 {
            currentItemIndex = currentIndex + 1
        } else {
            currentItemIndex = 0
        }
    }
    
    func didPressUndo() {
        if let lastResolvedItem = self.lastResolvedItem {
            RealmSubjects.shared.categorizeItem(lastResolvedItem, toCategory: nil)
            self.lastResolvedItem = nil
        }
    }
}
