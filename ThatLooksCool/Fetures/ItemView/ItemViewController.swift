//
//  ItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-02-28.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class ItemViewController: UIViewController {
            
    let itemDetailView: ItemDetailView
    weak var delegate: CompletableActionDelegate?
          
    init(item: Item) {
        self.itemDetailView = ItemDetailView(item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
        
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.view.backgroundColor = .clear
        self.hideKeyboardWhenTappedAround()
                
        let itemBackgroundView = UIView()
        itemBackgroundView.backgroundColor = TLCStyle.primaryBackgroundColor
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding

        itemBackgroundView.addSubview(itemDetailView)
        itemBackgroundView.constrainSubviewToBounds(itemDetailView, withInset: UIEdgeInsets(TLCStyle.elementMargin))
        
        stack.addArrangedSubview(itemBackgroundView)
        stack.addArrangedSubview(createSaveDeleteView())
        
        self.view.addSubview(stack)
        self.view.constrainSubviewToBounds(stack, onEdges: [.left, .right])
        self.view.constrainSubviewToBounds(stack, onEdges: [.bottom], withInset: UIEdgeInsets(TLCStyle.safeArea.bottom + 125))
    }
        
    private func createSaveDeleteView() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        let leftSpacer = UIView()
        let middleSpacer = UIView()
        let rightSpacer = UIView()
                
        let saveButton = Button()
        saveButton.backgroundColor = TLCStyle.progressIconColor
        saveButton.title = "Save"
        saveButton.action = { [weak self] button in
            self?.itemDetailView.saveChanges()
            button.setEnabled(false)
            self?.delegate?.complete()
        }
        
        let deleteButton = Button()
        deleteButton.backgroundColor = TLCStyle.destructiveIconColor
        deleteButton.title = "Delete"
        deleteButton.action = { [weak self] button in
            self?.itemDetailView.delete()
            button.setEnabled(false)
            self?.delegate?.complete()
        }
        
        stack.addArrangedSubview(leftSpacer)
        stack.addArrangedSubview(deleteButton)
        stack.addArrangedSubview(middleSpacer)
        stack.addArrangedSubview(saveButton)
        stack.addArrangedSubview(rightSpacer)

        stack.addConstraint(.init(item: leftSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
        stack.addConstraint(.init(item: middleSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
        
//        container.addSubview(stack)
//        container.constrainSubviewToBounds(stack, withInset: UIEdgeInsets(TLCStyle.topMargin))
                
        return stack
    }
}
