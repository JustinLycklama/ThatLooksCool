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

struct ItemAndForm {
    let itemCoordinator: MockItemCoordinator
    let formView: FormView
}

class CategorizeItemsViewController: AdViewController {

    private let animationSizeDuration: TimeInterval = 0.25
    
    private let trippleItemDisplayView = TripleItemZAzisView()
    
    private let itemControlView = ItemControlView()
    private var currentItemAndForm: ItemAndForm? = nil
    
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
    
    // Undo Items
    var lastResolvedItem: Item? = nil {
        didSet {
            // Only one of lastResolvedItem and lastDeletedItemMock can be set
            if (lastResolvedItem != nil) {
                lastDeletedItemMock = nil
            }
            
//            itemControlView.secondButtonEnabled = lastResolvedItem != nil || lastDeletedItemMock != nil
        }
    }
    
    var lastDeletedItemMock: MockItem? = nil {
        didSet {
            
            // Only one of lastResolvedItem and lastDeletedItemMock can be set
            if lastDeletedItemMock != nil {
                lastResolvedItem = nil
            }
            
//            itemControlView.secondButtonEnabled = lastResolvedItem != nil || lastDeletedItemMock != nil
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
            trippleItemDisplayView.setBadge(items.count)
            
            let defaultIndex: Int? = items.count > 0 ? 0 : nil
            
            if let item = _tempItem {
                currentItemIndex = items.firstIndex(of: item) ?? defaultIndex
                _tempItem = nil
            } else {
                currentItemIndex = defaultIndex
            }
            
            itemControlView.firstButtonEnabled = items.count > 0
            itemControlView.secondButtonEnabled = items.count > 0
            itemControlView.thirdButtonEnabled = items.count > 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categorize New Items"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
                
        // Stack Setup
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = TLCStyle.topLevelPadding + TLCStyle.interiorPadding
                        
        // Item Display
        let itemDisplay = createItemDisplay()
        
        stackView.addArrangedSubview(itemDisplay)
        
        contentView.addSubview(stackView)
        contentView.constrainSubviewToBounds(stackView, onEdges: [.top, .left, .right],
                                             withInset: UIEdgeInsets(top: TLCStyle.topLevelMargin, left: 0, bottom: 0, right: 0))
        
        addBackgroundImage()
        

        self.view.layoutIfNeeded()
        
        // Reactive
        RealmSubjects.shared.pendingItemsSubject.subscribe(onNext: { [weak self] (pendingItems: [Item]) in
                self?.items = pendingItems
        }, onError: { (err: Error) in

        }, onCompleted: {

        }) {

        }.disposed(by: disposeBag)
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if targetEnvironment(simulator)
        RealmSubjects.shared.removeAllPendingItems()
        RealmSubjects.shared.addPendingItem(title: "1")
        RealmSubjects.shared.addPendingItem(title: "2\nasd asd asd\nasd ads")
        RealmSubjects.shared.addPendingItem()
        #endif
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createItemDisplay() -> UIView {
        let itemDisplayAndNavigationView = UIView()
        
        let itemViewStack = UIStackView()
        itemViewStack.axis = .vertical
        itemViewStack.spacing = -TLCStyle.interiorPadding

        itemDisplayAndNavigationView.layer.cornerRadius = TLCStyle.cornerRadius
        itemDisplayAndNavigationView.backgroundColor = .clear //TLCStyle.secondaryBackgroundColor
        itemDisplayAndNavigationView.setContentHuggingPriority(.required, for: .vertical)
        itemDisplayAndNavigationView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                
        itemDisplayAndNavigationView.addSubview(itemViewStack)
        itemDisplayAndNavigationView.constrainSubviewToBounds(itemViewStack)

        itemViewStack.addArrangedSubview(trippleItemDisplayView)
        itemViewStack.addArrangedSubview(itemControlView)
        
        // Item Navigation
        itemControlView.delegate = self
        itemControlView.translatesAutoresizingMaskIntoConstraints = false
        
        itemControlView.shadowType = .border(radius: 10, offset: CGSize(width: 5, height: 5))
        
        itemControlView.addConstraint(NSLayoutConstraint.init(item: itemControlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))
        
        return itemDisplayAndNavigationView
    }
        
    private var isAnimatingOut: Bool = false
    private func updateItemDisplay() {
        let duration: TimeInterval = 0.33
                
        guard currentItemAndForm?.itemCoordinator.databaseObject?.isInvalidated ?? true || currentItem != currentItemAndForm?.itemCoordinator.databaseObject else {
            return
        }
        
        let createItemBlock = { [weak self] in
            guard let self = self else {
                return
            }
            
            if let currentItem = self.currentItem {
                
                let coordinator = MockItemCoordinator(item: currentItem)
                let newForm = FormView(fields: coordinator.modifiableFields())
                                
                newForm.alpha = 0
                newForm.setContentHuggingPriority(.required, for: .vertical)
                
                newForm.clipsToBounds = true
                newForm.layer.cornerRadius = 10
                newForm.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                newForm.setContentCompressionResistancePriority(.required, for: .vertical)
                                
//                newDisplayView.roundCorners(corners: [.topLeft, .topRight], radius: TLCStyle.cornerRadius)
                
                self.currentItemAndForm = ItemAndForm(itemCoordinator: coordinator, formView: newForm)
                
//                self.addChild(newDisplayController)
                self.trippleItemDisplayView.itemDisplayArea.addSubview(newForm)
                self.trippleItemDisplayView.itemDisplayArea.constrainSubviewToBounds(newForm)
                
                // Grow view to fit constraints
                UIView.animate(withDuration: self.animationSizeDuration) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    // Then make view visible
                    UIView.animate(withDuration: duration) {
                        newForm.alpha = 1
                    }
                }

            } else {
                // Grow to fit no view
                UIView.animate(withDuration: self.animationSizeDuration) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }
        }

        if let oldItemAndForm = currentItemAndForm {

            if !isAnimatingOut {
                isAnimatingOut = true
                
                UIView.animate(withDuration: 0.20, animations: {
                    oldItemAndForm.formView.alpha = 0
                    
                }, completion: { [weak self] _ in
                    oldItemAndForm.formView.removeFromSuperview()

                    self?.isAnimatingOut = false
                    self?.currentItemAndForm = nil
                    
                    createItemBlock()
                })
            }
        } else {
            createItemBlock()
        }
    }
    
    func undo() {
        if let lastResolvedItem = self.lastResolvedItem {
            RealmSubjects.shared.categorizeItem(lastResolvedItem, toCategory: nil)
            self.lastResolvedItem = nil
        } else if let lastDeletedMock = self.lastDeletedItemMock {
            RealmSubjects.shared.createItem(withMock: lastDeletedMock, toCategory: nil)
            self.lastDeletedItemMock = nil
        }
    }
}

extension CategorizeItemsViewController: CompletableWithCategoryDelegate {
    func complete(withCategory category: ItemCategory?) {
        self.dismiss(animated: true, completion: { [weak self] in
            if let currentCoordinator = self?.currentItemAndForm?.itemCoordinator {
                // Save selected item
                let item = currentCoordinator.saveItem()
                
                // Switch to next item
                self?.didPressThird()
                
                // Categorize old item
                RealmSubjects.shared.categorizeItem(item, toCategory: category)
                
                // Save old item for undo
                self?.lastResolvedItem = item
            }
        })
    }
}

extension CategorizeItemsViewController: ItemIterationDelegate {
    func didPressFirst() {
        if let currentCoordinator = currentItemAndForm?.itemCoordinator {
            lastDeletedItemMock = currentCoordinator.deleteItem()
            
            // Switch to next item
            self.didPressThird()
        }
    }
    
    func didPressSecond() {
        let categoriesViewController = DisplayCategoriesTableController()
        categoriesViewController.delegate = self
        
        self.present(categoriesViewController, animated: true, completion: nil)
    }
    
    // Next
    func didPressThird() {
        guard let currentIndex = currentItemIndex else {
            return
        }
        
        if currentIndex < items.count - 1 {
            currentItemIndex = currentIndex + 1
        } else {
            currentItemIndex = 0
        }
    }
}
