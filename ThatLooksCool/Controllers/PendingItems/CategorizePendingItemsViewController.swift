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
    let displayView: AnyItemDisplayView
}

class CategorizePendingItemsViewController: AdViewController {

    private var currentDisplayItemAndView: DisplayItemAndView? = nil
    private let itemDisplayArea = UIView()
    
    private let iterationView = ItemIterationView()
    
//    let previewView = UnresolvedItemPreviewView()
//    var detailViewArea = UIView()
    
//    let container = UIStackView()
    
    private var disposeBag = DisposeBag()
    
//    var currentItem: PendingItem? {
//        didSet {
//            updateItemPreview()
//            loadLocalPlaces()
//        }
//    }
    
    
    var currentItem: Item? {
        if let index = currentItemIndex {
            return items[index]
        }
        
        return nil
    }
    
    var currentItemIndex: Int? {
        didSet {
            updateItemDisplay()
//            loadLocalPlaces()
        }
    }
    
    var lastResolvedItem: Item? = nil {
        didSet {
            iterationView.canUndo = lastResolvedItem != nil
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
            let defaultIndex: Int? = items.count > 0 ? 0 : nil
            
            if let item = _tempItem {
                currentItemIndex = items.firstIndex(of: item) ?? defaultIndex
                _tempItem = nil
            } else {
                currentItemIndex = defaultIndex
            }
            
            iterationView.canPreviousNext = items.count > 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoriesViewController = CategoriesViewController()
        self.addChild(categoriesViewController)
        
        
        categoriesViewController.canAddCategories = true
        categoriesViewController.delegate = self
        
        let categoriesView = categoriesViewController.view!
        
        
//        let margin = TLCStyle.topLevelMargin
//        let padding = TLCStyle.topLevelPadding
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = TLCStyle.topLevelPadding
        
        stackView.addArrangedSubview(itemDisplayArea)
        stackView.addArrangedSubview(iterationView)
        stackView.addArrangedSubview(categoriesView)
        
        contentView.addSubview(stackView)

        
//        contentView.addSubview(previewView)
//        contentView.addSubview(detailViewArea)
        
        itemDisplayArea.setContentHuggingPriority(.required, for: .vertical)
        itemDisplayArea.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        iterationView.delegate = self
        iterationView.translatesAutoresizingMaskIntoConstraints = false
        iterationView.addConstraint(NSLayoutConstraint.init(item: iterationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))

        iterationView.backgroundColor = .cyan
        iterationView.layer.cornerRadius = 10
        
        categoriesView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        itemDisplayArea.layer.cornerRadius = 10
        itemDisplayArea.clipsToBounds = true
        itemDisplayArea.backgroundColor = .red
        
        categoriesView.layer.cornerRadius = 10
        
        categoriesView.layer.masksToBounds = true
        categoriesView.layer.isOpaque = false
        
        categoriesView.backgroundColor = .green
        
        
        contentView.constrainSubviewToBounds(stackView)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
//        contentView.constrainSubviewToBounds(previewView, onEdges: [.top, .left, .right])
//        contentView.constrainSubviewToBounds(categoriesView, onEdges: [.bottom, .left, .right])

//        contentView.addConstraint(NSLayoutConstraint.init(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: detailViewArea, attribute: .top, multiplier: 1, constant: -padding))
    
        
        
        ////
        
//
        RealmSubjects.shared.pendingItemsSubject.subscribe(onNext: { [weak self] (pendingItems: [Item]) in
                self?.items = pendingItems
        }, onError: { (err: Error) in

        }, onCompleted: {

        }) {

        }.disposed(by: disposeBag)
        
        
        
        
        RealmSubjects.shared.removeAllPendingItems()
        RealmSubjects.shared.addPendingItem(title: "1")
        RealmSubjects.shared.addPendingItem(title: "2\nasd asd asd\nasd ads")
        RealmSubjects.shared.addPendingItem(title: "3")
        
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
                let newDisplayView = AnyItemDisplayView(item: currentItem)
                
                newDisplayView.alpha = 0
                newDisplayView.backgroundColor = .blue
                newDisplayView.setContentHuggingPriority(.required, for: .vertical)
                
                self?.currentDisplayItemAndView = DisplayItemAndView(displayItem: currentItem, displayView: newDisplayView)
                self?.itemDisplayArea.addSubview(newDisplayView)
                self?.itemDisplayArea.constrainSubviewToBounds(newDisplayView, withInset: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
                
                
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
                    oldDisplayItemAndView.displayView.alpha = 0
                    
                }, completion: { [weak self] _ in
                    oldDisplayItemAndView.displayView.removeFromSuperview()

                    self?.isAnimatingOut = false
                    self?.currentDisplayItemAndView = nil
                    
                    createItemBlock()
                })
            }
        } else {
            createItemBlock()
        }
        
    }
    
    private func loadLocalPlaces() {
        guard let coordinate = currentItem?.coordinate else {
            return
        }
        
        FSPlacesRequest.init(coordinate: coordinate).request { (result: Result<FSPlace>) in
            //            switch result {
            //            case .success(let plants):
            ////                self?.plantList = plants
            //                print("Success")
            //            case .error(let err):
            //                print("Fail")
            //            }
            //
            //            self?.reloadData()
            //            self?.loadingView?.setLoading(false)
            //        }
        }
    }
}

extension CategorizePendingItemsViewController: CategorySelectionDelegate {
    func didSelectCategory(_ category: ItemCategory) {
        
        if let item = currentItem {

            
//            lastResolvedItem = RealmSubjects.shared.categorize(item: item, as: category)
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
//            RealmSubjects.shared.uncategorize(item: lastResolvedItem)
            self.lastResolvedItem = nil
        }
    }
}
