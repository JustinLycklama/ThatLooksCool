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

class ResolvedLocationsViewController: UIViewController {

    let margin: CGFloat = 32
    let padding: CGFloat = 16
    
    let actionHeight: CGFloat = 175
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        let realm = try! Realm(configuration: TLC_Constants.realmConfig)

        let locations = realm.objects(UnResolvedLocation.self)
        print(locations.count)
        

        self.view.backgroundColor = .gray

                
        let contentView = UIView()
        
        
        self.view.addSubview(contentView)
        self.view.constrainSubviewToBounds(contentView, withInset: UIEdgeInsets(top: margin*2, left: margin, bottom: margin, right: margin))
        
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
