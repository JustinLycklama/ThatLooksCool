//
//  SetupHelpViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import IntentsUI

class SetupHelpViewController: UIViewController {

    weak var delegate: CompletableActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        self.view.backgroundColor = TLCStyle.primaryBackgroundColor
        
        title = "Setup"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = TLCStyle.topLevelPadding
        
        // Location Intent
        let rememberLocationIntentButton = INUIAddVoiceShortcutButton(style: .blackOutline)
        rememberLocationIntentButton.translatesAutoresizingMaskIntoConstraints = false

        let intent = RememberLocationIntent()
        
        rememberLocationIntentButton.shortcut = INShortcut(intent: intent )
        rememberLocationIntentButton.delegate = self
        
        let locationTitle = UILabel()
        locationTitle.text = "Remember Location"
        locationTitle.style(.heading)
        
        let locationDetails = UILabel()
        locationDetails.numberOfLines = 0
        locationDetails.text = "This shortcut will be used to remember your location, when given phrase is spoken to siri. \n\nTry \'That Looks Cool'."
        locationDetails.style(.instructions)
        
        stack.addArrangedSubview(locationTitle)
        stack.addArrangedSubview(locationDetails)
        stack.addArrangedSubview(rememberLocationIntentButton)
        
        // Spacer
        let spacer = UIView()
        stack.addArrangedSubview(spacer)

        // Speech Intent
        let rememberSpeechIntentButton = INUIAddVoiceShortcutButton(style: .blackOutline)
        rememberSpeechIntentButton.translatesAutoresizingMaskIntoConstraints = false

        let rememberIntent = RememberPhraseIntent()
        
        rememberSpeechIntentButton.shortcut = INShortcut(intent: rememberIntent)
        rememberSpeechIntentButton.delegate = self
        
        let rememberTitle = UILabel()
        rememberTitle.text = "Remember Spoken Item"
        rememberTitle.style(.heading)
        
        let rememberDetails = UILabel()
        rememberDetails.numberOfLines = 0
        rememberDetails.text = "This shortcut will be used to remember the next thing you say to Siri. \n\nTry \'Remember'.\n\nExample: \'Hey Siri. Remember. Check out Game of Thrones\'."
        rememberDetails.style(.instructions)
        
        stack.addArrangedSubview(rememberTitle)
        stack.addArrangedSubview(rememberDetails)
        stack.addArrangedSubview(rememberSpeechIntentButton)
        
        // Spacer
        let spacer2 = UIView()
        stack.addArrangedSubview(spacer2)
        
        // Acknowledgements
        let ack = UILabel()
        ack.text = "About"
        ack.textAlignment = .right
        ack.style(.systemInfoLink)
        
        stack.addArrangedSubview(ack)
        
        view.addSubview(stack)
        view.constrainSubviewToBounds(stack, onEdges: [.top, .left, .right],
                                      withInset: UIEdgeInsets.init(top: TLCStyle.topLevelMargin,
                                                                   left: TLCStyle.topLevelMargin,
                                                                   bottom: 0,
                                                                   right: TLCStyle.topLevelMargin))
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Present the Add Shortcut view controller after the
    // user taps the "Add to Siri" button.
//    @objc
//    func addToSiri(_ sender: Any) {
//        let intent = NewItemIntent()
//
//        if let shortcut = INShortcut(intent: intent) {
//            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
//            viewController.modalPresentationStyle = .formSheet
//            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
//            present(viewController, animated: true, completion: nil)
//        }
//    }
}

extension SetupHelpViewController: INUIAddVoiceShortcutButtonDelegate {
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

extension SetupHelpViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SetupHelpViewController: INUIEditVoiceShortcutViewControllerDelegate {
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
