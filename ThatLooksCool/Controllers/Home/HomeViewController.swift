//
//  HomeController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

import TLCIntents
import TLCModel

import RealmSwift

import GoogleMobileAds

import RxSwift

import EasyNotificationBadge

// AppId: ca-app-pub-9795717139224841~5361159859

class HomeViewController: AdViewController {
            
    let disposeBag = DisposeBag()
    
    fileprivate let categoriesController = CategoriesViewController()
    fileprivate let zAxisView = TrippleItemZAzisView()

    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = "That Looks Cool"
//        self.navigationController?.view.backgroundColor = TLCStyle.navBarBackgroundColor
//        UINavigationBar.appearance().tintColor = TLCStyle.navBarBackgroundColor




        
//        edgesForExtendedLayout = []
//        self.navigationController?.navigationBar.isHidden = true
        
        // Layout
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding
        
        
        // Pending Items
        let pendingAndSetupLabel = UILabel()
        pendingAndSetupLabel.text = "New Items"
        pendingAndSetupLabel.style(.heading)
        
        let pendingItemsView = createPendingItemsView()
        
        stack.addArrangedSubview(pendingAndSetupLabel)
        stack.addArrangedSubview(pendingItemsView)
        
        // Categories

        let categoriesLabel = UILabel()
        categoriesLabel.text = "View by Category"
        categoriesLabel.style(.heading)
        
        let categoriesView = createCategoryView()
        
        stack.addArrangedSubview(categoriesLabel)
        stack.addArrangedSubview(categoriesView)

        // MapView: Future Feature
        
        /*let mapLabel = UILabel()
        mapLabel.text = "View by Map"
        mapLabel.style(.heading)
        
        let mapView = createMapView()
        
        stack.addArrangedSubview(mapLabel)
        stack.addArrangedSubview(mapView)*/

        contentView.addSubview(stack)
        contentView.constrainSubviewToBounds(stack)
    }
    
    // MARK: - View Creation
    
    private func createPendingItemsView() -> UIView {
        // Categorize Pending Items
        let pendingAndSetupStackView = UIStackView()
        pendingAndSetupStackView.axis = .horizontal
        pendingAndSetupStackView.alignment = .center
        pendingAndSetupStackView.distribution = .fillProportionally
        pendingAndSetupStackView.translatesAutoresizingMaskIntoConstraints = false
        pendingAndSetupStackView.spacing = TLCStyle.topLevelPadding
        
        pendingAndSetupStackView.addConstraint(.init(item: pendingAndSetupStackView,
                                                     attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72))
        
        // Categorize Action
        let categorizeView = ShadowView()
        
        categorizeView.addSubview(zAxisView)
        categorizeView.constrainSubviewToBounds(zAxisView, withInset: UIEdgeInsets(top: TLCStyle.topLevelPadding,
                                                                                   left: TLCStyle.topLevelPadding,
                                                                                   bottom: TLCStyle.interiorMargin,
                                                                                   right: TLCStyle.topLevelPadding))

        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(presentUnresolvedItems))
        categorizeView.addGestureRecognizer(tapG)

        // Settings Action
        let settingsView = ShadowView()
        settingsView.layer.borderWidth = 1
        settingsView.layer.borderColor = TLCStyle.viewBorderColor.cgColor
        
        let settingsImage = UIImageView()
        settingsView.addSubview(settingsImage)
        settingsView.constrainSubviewToBounds(settingsImage, withInset: UIEdgeInsets(TLCStyle.topLevelPadding))
        
        settingsImage.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        settingsImage.tintColor = TLCStyle.shadowColor
        
        settingsView.addConstraint(.init(item: settingsView, attribute: .width, relatedBy: .equal, toItem: settingsView, attribute: .height, multiplier: 1, constant: 0))
        
        let tapGSetup = UITapGestureRecognizer.init(target: self, action: #selector(openHelp))
        settingsView.addGestureRecognizer(tapGSetup)

        // Style Actions
        for view in [categorizeView, settingsView] {
            view.backgroundColor = .white
            view.layer.cornerRadius = 10

            view.translatesAutoresizingMaskIntoConstraints = false

            pendingAndSetupStackView.addArrangedSubview(view)
            pendingAndSetupStackView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: pendingAndSetupStackView, attribute: .height, multiplier: 1, constant: 0))
        }
        
        let pendingItemContainer = UIView()
        pendingItemContainer.addSubview(pendingAndSetupStackView)
        pendingItemContainer.constrainSubviewToBounds(pendingAndSetupStackView, withInset: UIEdgeInsets(top: 0, left: 0, bottom: TLCStyle.topLevelPadding, right: 0))
        
        RealmSubjects.shared.pendingItemCountSubject
            .subscribe(onNext: { [weak self] (count: Int) in
                self?.zAxisView.setBadge(count)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        return pendingItemContainer
    }
    
    private func createCategoryView() -> UIView {
        // View By Category
        categoriesController.title = "View Items By Category"
        categoriesController.canAddCategories = true
        categoriesController.delegate = self
    
        self.addChild(categoriesController)
        
        let categoriesView = categoriesController.view!
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        
        let categoriesContrainer = UIView()
        categoriesContrainer.backgroundColor = .clear
        
        categoriesContrainer.addSubview(categoriesView)
        categoriesContrainer.constrainSubviewToBounds(categoriesView, withInset: UIEdgeInsets(top: 0, left: 0, bottom: TLCStyle.topLevelPadding, right: 0))

        return categoriesContrainer
    }
    
    // MARK: - Actions
    
    @objc
    func openHelp() {
        let helpController = SetupHelpViewController()
        helpController.delegate = self
        
        let navc = UINavigationController(rootViewController: helpController)
        
        navc.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(navc, animated: true, completion: {
            navc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.close))
        })
    }
    
    @objc
    func presentUnresolvedItems() {
        let unresolvedItems = CategorizePendingItemsViewController()
        let navc = UINavigationController(rootViewController: unresolvedItems)
        
        navc.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(navc, animated: true, completion: {
            navc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.close))
        })
    }
    
    @objc
    func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CompletableActionDelegate
extension HomeViewController: CompletableActionDelegate {
    func complete() {
        self.dismiss(animated: true) {
            
        }
    }
}

// MARK: - CategorySelectionDelegate
extension HomeViewController: CategorySelectionDelegate {
    func editCategory(_ category: ItemCategory?) {
        let editView = EditCategoryViewController(category: category)
        
        editView.delegate = self
        editView.modalPresentationStyle = .formSheet
        
        self.present(editView, animated: true, completion: nil)
    }
    
    func selectCategory(_ category: ItemCategory) {
        let itemsVc = ViewCategoryItemsViewController(category: category)
        itemsVc.delegate = self
        
        let navController = UINavigationController(rootViewController: itemsVc)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
}
