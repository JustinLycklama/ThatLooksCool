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

    let previewView = UnresolvedItemPreviewView()
    var detailViewArea = UIView()
    
    private var disposeBag = DisposeBag()
    
    var currentItem: PendingItem? {
        didSet {
            updateItemPreview()
            loadLocalPlaces()
        }
    }
    
    var items: [PendingItem] = [] {
        didSet {
            if let firstItem = items.first,
                currentItem == nil {
                currentItem = firstItem
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoriesViewController = CategoriesViewController()
        self.addChild(categoriesViewController)
        
        categoriesViewController.canAddCategories = true
        
        detailViewArea = categoriesViewController.view
        
        
        let margin = TLCStyle.topLevelMargin
        let padding = TLCStyle.topLevelPadding
        
        contentView.addSubview(previewView)
        contentView.addSubview(detailViewArea)
        
        previewView.setContentHuggingPriority(.required, for: .vertical)
        previewView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailViewArea.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        previewView.layer.cornerRadius = 10
        detailViewArea.layer.cornerRadius = 10
        
        detailViewArea.layer.masksToBounds = true
        detailViewArea.layer.isOpaque = false
        
        previewView.backgroundColor = .red
        detailViewArea.backgroundColor = .green
        
        contentView.constrainSubviewToBounds(previewView, onEdges: [.top, .left, .right])
        contentView.constrainSubviewToBounds(detailViewArea, onEdges: [.bottom, .left, .right])

        contentView.addConstraint(NSLayoutConstraint.init(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: detailViewArea, attribute: .top, multiplier: 1, constant: -padding))
        
        
        
        ////
        
//
        RealmSubjects.shared.pendingItemsSubject.subscribe(onNext: { [weak self] (unresolvedItems: [PendingItem]) in
            DispatchQueue.main.async {
                self?.items = unresolvedItems

            }
        }, onError: { (err: Error) in

        }, onCompleted: {

        }) {

        }.disposed(by: disposeBag)
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
