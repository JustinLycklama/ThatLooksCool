//
//  ViewCategoryItemsViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-06.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import RxSwift

import TLCModel
import ClassicClient

class DisplayItemsTableController: AdViewController {
    
    private let disposeBag = DisposeBag()
    
    private let category: ItemCategory
    
    weak var delegate: CompletableActionDelegate?
    
    init(category: ItemCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        // Layout
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding
        
        // Items
        let itemsView = createItemsView()
        
        let itemsLabel = UILabel()
        itemsLabel.text = "Items"
        itemsLabel.style(TextStyle.heading)
        
        stack.addArrangedSubview(itemsLabel)
        stack.addArrangedSubview(itemsView)
        
        // MapView: Future Feature
        //        let mapLabel = UILabel()
        //        mapLabel.text = "View by Map"
        //        mapLabel.style(.heading)
        //
        //        let mapView = createMapView()
        //
        //        stack.addArrangedSubview(mapLabel)
        //        stack.addArrangedSubview(mapView)
        
        contentView.addSubview(stack)
        contentView.constrainSubviewToBounds(stack)
        
        addBackgroundImage()
    }
    
    @objc func close() {
        delegate?.complete()
    }
    
    private func createMapView() -> UIView {
        let mapView = ShadowView()
        mapView.shadowType = .contact(distance: 10)
        
        let mapImage = UIImageView()
        mapImage.image = UIImage(named: "map_image")
        mapImage.layer.cornerRadius = TLCStyle.cornerRadius
        mapImage.clipsToBounds = true
        
        mapView.addSubview(mapImage)
        mapView.constrainSubviewToBounds(mapImage)
        
        mapView.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 128))
        
        return mapView
    }
    
    private func createItemsView() -> UIView {
        
        let categoryCellConfig = CellConfig { (item: Item, cell: ItemCell) in
            cell.displayItem(displayable: item)
        } performAction: { [weak self] (item: Item) in
            
            let editCategoryViewController = EditCategoryViewController(category: nil)
            editCategoryViewController.delegate = self
            
            self?.present(editCategoryViewController, animated: true, completion: nil)
        } itemEdited: { (item: Item) in
            
            
        } itemDeleted: { (item: Item) in
            
        }
        
        let actionCellConfig = CellConfig<Void, AddCell> { (_) in
            let editCategoryViewController = EditCategoryViewController(category: nil)
            editCategoryViewController.delegate = self
            
            self.present(editCategoryViewController, animated: true, completion: nil)
        }
            
        let itemsTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: categoryCellConfig)
        itemsTable.canPerformAction = true
                
        RealmSubjects.shared.resolvedItemSubjectsByCategory[category]?.subscribe(
            onNext: { (items: [Item]) in
                itemsTable.setItems(items: items)
                
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
            
        }.disposed(by: disposeBag)
                
        return itemsTable
    }
}

extension DisplayItemsTableController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true, completion: nil)
    }
}
