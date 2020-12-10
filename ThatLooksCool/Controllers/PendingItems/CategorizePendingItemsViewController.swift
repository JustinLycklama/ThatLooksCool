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

class CategorizePendingItemsViewController: AdViewController {

    
    private let previewView = UnresolvedItemPreviewView()
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
    
    
    var currentItem: PendingItem? {
        if let index = currentItemIndex {
            return items[index]
        }
        
        return nil
    }
    
    var currentItemIndex: Int? {
        didSet {
            updateItemPreview()
            loadLocalPlaces()
        }
    }
    
    var lastResolvedItem: ResolvedItem? = nil {
        didSet {
            iterationView.canUndo = lastResolvedItem != nil
        }
    }
    
    var _tempItem: PendingItem?
    var items: [PendingItem] = [] {
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
        
        stackView.addArrangedSubview(previewView)
        stackView.addArrangedSubview(iterationView)
        stackView.addArrangedSubview(categoriesView)
        
        contentView.addSubview(stackView)

        
//        contentView.addSubview(previewView)
//        contentView.addSubview(detailViewArea)
        
        previewView.setContentHuggingPriority(.required, for: .vertical)
        previewView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        iterationView.delegate = self
        iterationView.translatesAutoresizingMaskIntoConstraints = false
        iterationView.addConstraint(NSLayoutConstraint.init(item: iterationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))

        iterationView.backgroundColor = .cyan
        iterationView.layer.cornerRadius = 10
        
        categoriesView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        previewView.layer.cornerRadius = 10
        categoriesView.layer.cornerRadius = 10
        
        categoriesView.layer.masksToBounds = true
        categoriesView.layer.isOpaque = false
        
        previewView.backgroundColor = .red
        categoriesView.backgroundColor = .green
        
        
        contentView.constrainSubviewToBounds(stackView)
        
//        contentView.constrainSubviewToBounds(previewView, onEdges: [.top, .left, .right])
//        contentView.constrainSubviewToBounds(categoriesView, onEdges: [.bottom, .left, .right])

//        contentView.addConstraint(NSLayoutConstraint.init(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: detailViewArea, attribute: .top, multiplier: 1, constant: -padding))
    
        
        
        ////
        
//
        RealmSubjects.shared.pendingItemsSubject.subscribe(onNext: { [weak self] (pendingItems: [PendingItem]) in
                self?.items = pendingItems
        }, onError: { (err: Error) in

        }, onCompleted: {

        }) {

        }.disposed(by: disposeBag)
        
        
        
        
        RealmSubjects.shared.removeAllPendingItems()
        RealmSubjects.shared.addPendingItem(title: "1")
        RealmSubjects.shared.addPendingItem(title: "2")
        RealmSubjects.shared.addPendingItem(title: "3")
        
    }
    
    
    private func updateItemPreview() {
        previewView.setItem(item: currentItem)
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
    func didSelectCategory(_ category: ResolvedItemCategory) {
        
        if let item = currentItem {
            lastResolvedItem = RealmSubjects.shared.categorize(item: item, as: category)
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
            RealmSubjects.shared.uncategorize(item: lastResolvedItem)
            self.lastResolvedItem = nil
        }
    }
    
    
}
