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
import RxSwift

import Onboard

class HomeViewController: AdViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        TestRequest.init().request { (result: Result<GooglePlace>) in
//
//        }
  
        let url = URL(string: "https://goo.gl/maps/WD3ZsR5zqGVgahcq8")!
        
//        url.requestHTTPStatus { (test: Int?) in
//            
//        }
//        
        
        ////
        let firstPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            }
        
        // Image
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background"), contents: [firstPage])

        // Video
//        let bundle = Bundle.main.mainBundle()
//        let moviePath = bundle.pathForResource("yourVid", ofType: "mp4")
//        let movieURL = NSURL(fileURLWithPath: moviePath!)

//        let onboardingVC = OnboardingViewController(contents: [firstPage, secondPage, thirdPage])
        
//        self.present(onboardingVC!, animated: true, completion: nil)
        
        self.title = "That Looks Cool"
        
        // Layout
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TLCStyle.topLevelPadding
//        stack.distribution = .fillProportionally
        
        
        // Pending Items
        let pendingAndSetupLabel = UILabel()
        pendingAndSetupLabel.text = "Categorize New Entries"
        pendingAndSetupLabel.style(TextStyle.heading)
        
        let pendingItemsView = createPendingItemsView()
        
        stack.addArrangedSubview(pendingAndSetupLabel)
        stack.addArrangedSubview(pendingItemsView)
        
        // Categories

        let categoriesLabel = UILabel()
        categoriesLabel.text = "Browse Categories"
        categoriesLabel.style(TextStyle.heading)
        
        let categoriesView = createCategoryView()
        
        stack.addArrangedSubview(categoriesLabel)
        stack.addArrangedSubview(categoriesView)

        contentView.addSubview(stack)
        contentView.constrainSubviewToBounds(stack)
        
        addBackgroundImage()
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
        let zAxisView = TripleItemZAzisView()
        let categorizeView = ShadowView()
                
        categorizeView.addSubview(zAxisView)
        categorizeView.constrainSubviewToBounds(zAxisView, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin,
                                                                                   left: TLCStyle.topLevelPadding,
                                                                                   bottom: TLCStyle.interiorMargin,
                                                                                   right: TLCStyle.topLevelPadding))

        let itemControl = ItemControlView()
        itemControl.firstButtonEnabled = false
        itemControl.secondButtonEnabled = false
        itemControl.thirdButtonEnabled = false
        
        categorizeView.addSubview(itemControl)
        categorizeView.constrainSubviewToBounds(itemControl, onEdges: [.bottom, .left, .right],
                                                withInset: UIEdgeInsets(top: 0,
                                                                        left: TLCStyle.topLevelPadding,
                                                                        bottom: -TLCStyle.interiorMargin,
                                                                        right: TLCStyle.topLevelPadding))
        itemControl.addConstraint(NSLayoutConstraint.init(item: itemControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        
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
            .subscribe(onNext: { (count: Int) in
                zAxisView.setBadge(count)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        return pendingItemContainer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RealmSubjects.shared.setupCategoriesIfNone()
    }
    
    private func createCategoryView() -> UIView {
        // View By Category
        
        let categoryCellConfig = TableCellConfig { (category: ItemCategory, cell: CategoryCell) in
            cell.displayCategory(displayable: category)
        } performAction: { [weak self]  (category: ItemCategory) in
            let itemsVc = DisplayItemsTableController(category: category)
            itemsVc.delegate = self
            
            let navController = UINavigationController(rootViewController: itemsVc)
            navController.modalPresentationStyle = .fullScreen
            
            self?.present(navController, animated: true, completion: nil)
        }
        
        let actionCellConfig = TableCellConfig<Void, AddCell> { (_) in
            let editCategoryViewController = EditCategoryViewController(category: nil)
            editCategoryViewController.delegate = self
            
            self.present(editCategoryViewController, animated: true, completion: nil)
            
        }
            
        let categoriesTable = ActionableTableView(actionConfig: actionCellConfig, itemConfig: categoryCellConfig)
        categoriesTable.canPerformAction = true

        
//        categoriesTable.layer.borderWidth = 1
//        categoriesTable.layer.borderColor = UIColor.red.cgColor
        
//        categoriesTable.title = "View Items By Category"
//        categoriesTable.delegate = self
    
//        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        
//        let categoriesView = UIView()
//        categoriesView.backgroundColor = .clear
//
//        categoriesView.addSubview(categoriesTable)
//        categoriesView.constrainSubviewToBounds(categoriesTable, withInset: UIEdgeInsets(top: 0, left: 0, bottom: TLCStyle.topLevelPadding, right: 0))

        RealmSubjects.shared.resolvedItemCategoriesSubject
            .subscribe(onNext: { (categories: [ItemCategory]) in
                categoriesTable.setItems(items: categories)
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)

        
        return categoriesTable
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
        let unresolvedItems = CategorizeItemsViewController()
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
