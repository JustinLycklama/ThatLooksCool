//
//  ItemDestinationViewController.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2021-01-28.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

import Social
import MobileCoreServices

struct NameAndShortLocation {
    let name: String?
    let shortLocationUrl: URL?
}

class ItemDestinationViewController: UIViewController {
    
    let tableview = UITableView()
    
    var overridableItem: Item? {
        didSet {
            tableview.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }
    
    var shareData: NameAndShortLocation? {
        didSet {
            tableview.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray6
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.frame = self.view.bounds
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(tableview)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RealmObjects.shared.findOutItem() { item in
            self.overridableItem = item
        }
        
        handleSharedFile { (shareData: NameAndShortLocation) in
            self.shareData = shareData
        }
    }
    
    private func handleSharedFile(completion: @escaping (NameAndShortLocation) -> Void) {
        
        var name: String?
        var link: URL?
        
        let dispatchGroup = DispatchGroup()
        
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        for provider in attachments {
            
            // Check for 'Data' type to contain our name
            if provider.hasItemConformingToTypeIdentifier(kUTTypeData as String) {
                
                dispatchGroup.enter()
                provider.loadItem(forTypeIdentifier: kUTTypeData as String, options: nil) { (data, error) in
                    guard error == nil else { return }
                    
                    if let string = data as? String {
                        name = string
                    }
                    
                    dispatchGroup.leave()
                }}
            
            // Check for 'URL' type to get our shortened maps URL
            if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                
                dispatchGroup.enter()
                provider.loadItem(forTypeIdentifier:kUTTypeURL as String, options: nil) { (data, error) in
                    guard error == nil else { return }
                    
                    if let url = data as? URL{
                        link = url
                    }
                    
                    dispatchGroup.leave()
                }}
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(NameAndShortLocation(name: name, shortLocationUrl: link))
        }
    }
}

extension ItemDestinationViewController: UITableViewDelegate, UITableViewDataSource {
    
    private var newItemEnabled: Bool {
        shareData != nil
    }
    
    private var overrideItemEnabled: Bool {
        shareData != nil && overridableItem != nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "New Item"
            cell.isUserInteractionEnabled = newItemEnabled
            cell.textLabel?.isUserInteractionEnabled = newItemEnabled
        } else {
            cell.textLabel?.text = "Override Item"
            cell.isUserInteractionEnabled = overrideItemEnabled
            cell.textLabel?.isUserInteractionEnabled = overrideItemEnabled
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0, let shareData = shareData {
            let shareViewController = ShareViewController(overridableItem: nil, shareData: shareData)
            self.navigationController?.pushViewController(shareViewController, animated: true)
        } else if let item = overridableItem, let shareData = shareData {
            let shareViewController = ShareViewController(overridableItem: item, shareData: shareData)
            self.navigationController?.pushViewController(shareViewController, animated: true)
        }
    }
    
}
