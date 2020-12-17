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

    let test = UITableViewController()
    
    public static let Tast_Ad_Unit_Id = "ca-app-pub-3940256099942544/2934735716"
    
    let margin: CGFloat = 32
    let padding: CGFloat = 16
    
    let actionHeight: CGFloat = 175
    
    let disposeBag = DisposeBag()
    
    fileprivate let categoriesController = CategoriesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isHidden = true

        RealmSubjects.shared.pendingItemCountSubject
            .subscribe(onNext: { (count: Int) in
                print(count)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
//        let realm = try! Realm(configuration: TLC_Constants.realmConfig)
//
//        let locations = realm.objects(UnResolvedLocation.self)
//        print(locations.count)


        
//        addBannerViewToView(adBannerView)
       
        
        
//        self.view.constrainSubviewToBounds(contentView, withInset: UIEdgeInsets(top: margin*2, left: margin, bottom: margin, right: margin))
        
        // Actions
        let horStackView = UIStackView()
        horStackView.axis = .horizontal
        horStackView.alignment = .center
        horStackView.distribution = .fillEqually
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.spacing = padding
        
        // Map Action
        let mapView = TitleContentView()
        mapView.titleLabel.text = "Map"
        
        let mapImage = UIImageView()
        mapView.contentView.addSubview(mapImage)
        mapView.contentView.constrainSubviewToBounds(mapImage)

        mapView.badge(text: "1")
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(presentUnresolvedItems))
        mapView.addGestureRecognizer(tapG)
        mapView.isUserInteractionEnabled = true
        
//        let badgeView = BadgeHub(view: mapView)
//        badgeView.increment()
        
        // Unresolved Action
        let unresolvedView = TitleContentView()
        unresolvedView.titleLabel.text = "UnResolved"

        // Style
        for view in [mapView, unresolvedView] {
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            horStackView.addArrangedSubview(view)
            horStackView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: horStackView, attribute: .height, multiplier: 1, constant: 0))
        }
        
        
        // Resolved Locations
        
        
        let navController = UINavigationController(rootViewController: categoriesController)

        categoriesController.canAddCategories = true
        categoriesController.delegate = self
        

        self.addChild(navController)
        
        let categoriesView = navController.view!
        
        categoriesView.backgroundColor = .white
        categoriesView.layer.cornerRadius = 10
        
        categoriesView.layer.masksToBounds = true
        categoriesView.layer.isOpaque = false
        
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        

        // Layout
        contentView.addSubview(horStackView)
        contentView.addSubview(categoriesView)
        
        
        let views = ["actions" : horStackView, "locations" : categoriesView]
        let metrics = ["margin" : margin, "padding" : padding, "actionHeight" : actionHeight]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margin)-[actions(actionHeight)]-(padding)-[locations]-(0)-|", options: .alignAllCenterX, metrics: metrics, views: views)
        
        
        let horActions = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[actions]-(0)-|", options: .alignAllCenterY, metrics: metrics, views: views)
        let horLocations = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[locations]-(0)-|", options: .alignAllCenterY, metrics: metrics, views: views)

        contentView.addConstraints(verticalConstraints + horActions + horLocations)
    }
    
    // Present the Add Shortcut view controller after the
    // user taps the "Add to Siri" button.
    @objc
    func addToSiri(_ sender: Any) {
//        let intent = NewItemIntent()
//
//        if let shortcut = INShortcut(intent: intent) {
//            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
//            viewController.modalPresentationStyle = .formSheet
//            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
//            present(viewController, animated: true, completion: nil)
//        }
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

extension HomeViewController: CategorySelectionDelegate {
    func didSelectCategory(_ category: ItemCategory) {
        
        let newVc = ResolvedItemsViewController(category: category)
        
        categoriesController.navigationController?.pushViewController(newVc, animated: true)
    }
}
