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

    override func viewDidLoad() {
        super.viewDidLoad()

        let stack = UIStackView()
        stack.axis = .vertical
        
        // Location Intent
        let rememberLocationIntentButton = INUIAddVoiceShortcutButton(style: .blackOutline)
        rememberLocationIntentButton.translatesAutoresizingMaskIntoConstraints = false

        let intent = RememberLocationIntent()
        
        rememberLocationIntentButton.shortcut = INShortcut(intent: intent )
        rememberLocationIntentButton.delegate = self
        
//        rememberLocationIntentButton.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
        
        stack.addArrangedSubview(rememberLocationIntentButton)
        
        // Speech Intent
        let rememberSpeechIntentButton = INUIAddVoiceShortcutButton(style: .blackOutline)
        rememberSpeechIntentButton.translatesAutoresizingMaskIntoConstraints = false

        let rememberIntent = RememberPhraseIntent()
        
        rememberSpeechIntentButton.shortcut = INShortcut(intent: rememberIntent)
        rememberSpeechIntentButton.delegate = self
        
//        rememberSpeechIntentButton.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
        
        stack.addArrangedSubview(rememberSpeechIntentButton)
        
        view.addSubview(stack)
        view.constrainSubviewToBounds(stack)
        
        // Do any additional setup after loading the view.
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
