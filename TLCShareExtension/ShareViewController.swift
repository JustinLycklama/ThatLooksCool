//
//  ShareViewController.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2020-12-04.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        setupNavBar()
        handleSharedFile()
    }
    
    private func setupNavBar() {
        
        self.navigationItem.title = "My app"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }
    
    private func handleSharedFile() {
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
//        let contentType = kUTTypeData as String
        for provider in attachments {
            
            
            
            // Check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(kUTTypeData as String) {
                provider.loadItem(forTypeIdentifier: kUTTypeData as String,
                                  options: nil) { [unowned self] (data, error) in
                    // Handle the error here if you want
                    guard error == nil else { return }
                    
                    if let url = data as? URL,
                       let imageData = try? Data(contentsOf: url) {
//                        self.save(imageData, key: "imageData", value: imageData)
                    } else if let string = data as? String {
                        print("lol")
                    }
                }}
            
            
            // Check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                provider.loadItem(forTypeIdentifier:kUTTypeURL as String,
                                  options: nil) { [unowned self] (data, error) in
                    // Handle the error here if you want
                    guard error == nil else { return }
                    
                    if let url = data as? URL{
                        print("Sweet")
                    } else if let string = data as? String {
                        print("lol")
                    }
                }}
            
        }
    }
    
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
