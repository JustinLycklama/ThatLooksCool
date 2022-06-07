//
//  NewItemsViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-04-17.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel

class NewItemsViewController: UIViewController {
    
    var items = [Item]()
    
    var currentItemIndex: Int? {
        didSet {
            if let index = currentItemIndex {
                displayItem(items[index])
            } else {
                displayItem(nil)
            }
        }
    }
    
    let itemsAreaView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let banner = ApplicationBanner(titleInfo: BannerTitleInfo(accentString: "What", plainString: "Looks Cool?", textLeftAligned: false),
                                       withSearchBarAndNewItems: false)
        banner.delegate = self
        
        self.view.backgroundColor = .clear
        self.hideKeyboardWhenTappedAround()
  
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = TLCStyle.primaryBackgroundColor

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topPadding

        stack.addArrangedSubview(itemsAreaView)
        stack.addArrangedSubview(createActionIconsView())
                    
        let content = HeaderContentLayout(header: banner, content: stack, spacing: TLCStyle.topPadding)
        content.backgroundColor = TLCStyle.primaryBackgroundColor
        
        self.view.addAndConstrainSubview(AdContainerLayout(rootViewController: self, content: content))
        
        listenToDatabaseItems()
    }
    
    private func listenToDatabaseItems() {
        DatabaseListener.shared.newItems { [weak self] (observation: DatabaseObservation<Item>) in
            var nextItemIndex = self?.currentItemIndex ?? 0
            
            switch observation {
            case .initial(let newItems):
                self?.items = newItems
                
            case .update(let newItems, deletions: let deletions, insertions: _, modifications: _):
                self?.items = newItems
                                
                if let currentIndex = self?.currentItemIndex, deletions.contains(currentIndex) {
                    nextItemIndex += 1
                }
                
                if nextItemIndex >= newItems.count {
                    nextItemIndex = 0
                }
                
            case .error(let error):
                error.presentToUser()
            }
            
            self?.currentItemIndex = (self?.items.count ?? 0) > 0 ? nextItemIndex : nil
        }
        
        // TODO: Remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let mock = MockItem()
            mock.title = "New Item"
            
            Item.create(withMock: mock, toCategory: nil)
        }
    }
    
    private func createActionIconsView() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        
//        let leftSpacer = UIView()
//        let middleSpacer = UIView()
//        let rightSpacer = UIView()
//
//        let saveButton = Button()
//        saveButton.backgroundColor = TLCStyle.progressIconColor
//        saveButton.title = "Save"
//        saveButton.action = { [weak self] button in
//            self?.itemDetailView.saveChanges()
//            button.setEnabled(false)
//            self?.delegate?.complete()
//        }
//
//        let deleteButton = Button()
//        deleteButton.backgroundColor = TLCStyle.destructiveIconColor
//        deleteButton.title = "Delete"
//        deleteButton.action = { [weak self] button in
//            self?.itemDetailView.delete()
//            button.setEnabled(false)
//            self?.delegate?.complete()
//        }
//
//        stack.addArrangedSubview(leftSpacer)
//        stack.addArrangedSubview(deleteButton)
//        stack.addArrangedSubview(middleSpacer)
//        stack.addArrangedSubview(saveButton)
//        stack.addArrangedSubview(rightSpacer)
//
//        stack.addConstraint(.init(item: leftSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
//        stack.addConstraint(.init(item: middleSpacer, attribute: .width, relatedBy: .equal, toItem: rightSpacer, attribute: .width, multiplier: 1, constant: 0))
        
        return stack
    }
    
    private func displayItem(_ item: Item?) {
        for view in itemsAreaView.subviews {
            view.removeFromSuperview()
        }
        
        if let item = item {
            let newItemView = ItemDetailView(item: item)
            
            itemsAreaView.addSubview(newItemView)
            itemsAreaView.constrainSubviewToBounds(newItemView)
        }
    }
}

extension NewItemsViewController: BannerDelegate {
    func settingsPressed() {
        
    }
    
    func secondaryIconPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension Error {
    func presentToUser(_ customMessage: String? = nil) {
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            let alert = UIAlertController(title: customMessage ?? "Error", message: localizedDescription, preferredStyle: .alert)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
