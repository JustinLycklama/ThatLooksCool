//
//  ResolvedLocationsViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-03.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient
import IntentsUI

import TLCIntents
import TLCModel

import RealmSwift

import GoogleMobileAds

import EasyNotificationBadge

// AppId: ca-app-pub-9795717139224841~5361159859

class ResolvedLocationsViewController: UIViewController {

    public static let Tast_Ad_Unit_Id = "ca-app-pub-3940256099942544/2934735716"
    
    let margin: CGFloat = 32
    let padding: CGFloat = 16
    
    let actionHeight: CGFloat = 175
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        edgesForExtendedLayout = []

        
        let realm = try! Realm(configuration: TLC_Constants.realmConfig)

        let locations = realm.objects(UnResolvedLocation.self)
        print(locations.count)
        

        self.view.backgroundColor = .gray

                
        let contentView = UIView()
        let bannerView = UIView()
        
        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)

        
        adBanner.adUnitID = ResolvedLocationsViewController.Tast_Ad_Unit_Id
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
        
        bannerView.backgroundColor = .white
        bannerView.layer.cornerRadius = 10
        
        bannerView.addSubview(adBanner)

        bannerView.addConstraint(NSLayoutConstraint.init(item: adBanner, attribute: .centerX, relatedBy: .equal, toItem: bannerView, attribute: .centerX, multiplier: 1, constant: 0))
        bannerView.constrainSubviewToBounds(adBanner, onEdges: [.top, .bottom], withInset: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        
//        addBannerViewToView(adBannerView)
        
        UIApplication.shared
        
        self.view.addSubview(contentView)
        self.view.addSubview(bannerView)

        contentView.backgroundColor = .blue
        
        self.view.constrainSubviewToBounds(contentView, onEdges: [.top, .left, .right], withInset: UIEdgeInsets(top: margin*2, left: margin, bottom: margin, right: margin))
        self.view.constrainSubviewToBounds(bannerView, onEdges: [.bottom, .left, .right])

        self.view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: adBanner, attribute: .top, multiplier: 1, constant: -margin))
        
        
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
        
//        let badgeView = BadgeHub(view: mapView)
//        badgeView.increment()
        
        // Unresolved Action
        let unresolvedView = TitleContentView()
        unresolvedView.titleLabel.text = "UnResolved"

        
        let button = INUIAddVoiceShortcutButton(style: .blackOutline)
        button.translatesAutoresizingMaskIntoConstraints = false

        let intent = NewItemIntent()
        
        button.shortcut = INShortcut(intent: intent )
        button.delegate = self
        
        unresolvedView.addSubview(button)
        unresolvedView.constrainSubviewToBounds(button)

        button.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
        
        // Style
        for view in [mapView, unresolvedView] {
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            horStackView.addArrangedSubview(view)
            horStackView.addConstraint(NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: horStackView, attribute: .height, multiplier: 1, constant: 0))
        }
        
        
        // Resolved Locations
        let resolvedLocationsView = TitleContentView()
        
        resolvedLocationsView.backgroundColor = .white
        resolvedLocationsView.layer.cornerRadius = 10
        
        resolvedLocationsView.translatesAutoresizingMaskIntoConstraints = false
        

        // Layout
        contentView.addSubview(horStackView)
        contentView.addSubview(resolvedLocationsView)
        
        let views = ["actions" : horStackView, "locations" : resolvedLocationsView]
        let metrics = ["margin" : margin, "padding" : padding, "actionHeight" : actionHeight]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[actions(actionHeight)]-(padding)-[locations]-(0)-|", options: .alignAllCenterX, metrics: metrics, views: views)
        
        
        let horActions = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[actions]-(0)-|", options: .alignAllCenterY, metrics: metrics, views: views)
        let horLocations = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[locations]-(0)-|", options: .alignAllCenterY, metrics: metrics, views: views)

        contentView.addConstraints(verticalConstraints + horActions + horLocations)
    }
    
    // Present the Add Shortcut view controller after the
    // user taps the "Add to Siri" button.
    @objc
    func addToSiri(_ sender: Any) {
        let intent = NewItemIntent()
        
        if let shortcut = INShortcut(intent: intent) {
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
            present(viewController, animated: true, completion: nil)
        }
    }

}





extension ResolvedLocationsViewController: INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    
}

extension ResolvedLocationsViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ResolvedLocationsViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
