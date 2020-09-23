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

class CategorizeUnresolvedViewController: AdViewController {

    let previewView = UnresolvedItemPreviewView()
    let detailViewArea = UIView()
    
    private var disposeBag = DisposeBag()
    
    var currentItem: UnresolvedLocation? {
        didSet {
            updateItemPreview()
        }
    }
    
    var items: [UnresolvedLocation] = [] {
        didSet {
            if let firstItem = items.first,
                currentItem == nil {
                currentItem = firstItem
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margin = TLCStyle.topLevelMargin
        let padding = TLCStyle.topLevelPadding
        
        contentView.addSubview(previewView)
        contentView.addSubview(detailViewArea)
        
        previewView.setContentHuggingPriority(.required, for: .vertical)
        previewView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailViewArea.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        previewView.layer.cornerRadius = 10
        detailViewArea.layer.cornerRadius = 10
        
        
        (previewView).backgroundColor = .red
        detailViewArea.backgroundColor = .green
        
        contentView.constrainSubviewToBounds(previewView, onEdges: [.top, .left, .right])
        contentView.constrainSubviewToBounds(detailViewArea, onEdges: [.bottom, .left, .right])

        contentView.addConstraint(NSLayoutConstraint.init(item: previewView, attribute: .bottom, relatedBy: .equal, toItem: detailViewArea, attribute: .top, multiplier: 1, constant: -padding))
        
        
        
        ////
        
        
        UnresolvedItemModel.sharedInstance.unresolvedItemsSubject.subscribe(onNext: { [weak self] (unresolvedItems: [UnresolvedLocation]) in
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
    
    
}
