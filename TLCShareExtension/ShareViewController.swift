//
//  ShareViewController.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2020-12-04.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import TLCModel
import ClassicClient

class ShareViewController: UIViewController {
    
//    var item: Item?
    var shareData: NameAndShortLocation
    
//    var formView: FormView?
    let mockItemCoordinator: MockItemCoordinator
    
    init(overridableItem item: Item?, shareData: NameAndShortLocation) {
//        self.item = item
        self.shareData = shareData
        
        self.mockItemCoordinator = MockItemCoordinator(item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.navigationItem.title = mockItemCoordinator.databaseObject == nil ? "New Item" : "Override Item"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
                            
        let displayView = createDisplayView()

        displayView.frame = self.view.bounds
        displayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(displayView)
    }
    
    func createDisplayView() -> UIView {
        let itemViewStack = UIStackView()
        itemViewStack.axis = .vertical
        itemViewStack.spacing = -TLCStyle.elementPadding

//        let mock = MockItem(item: item)
//        mock.title = shareData.name
        
        let itemController = FormView(fields: mockItemCoordinator.modifiableFields())

//        itemController.sizeSubscriber = { requestedSize in
//            let heightConstraint = NSLayoutConstraint.init(item: itemController, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: requestedSize.height)
//
//            heightConstraint.priority = .defaultHigh
//            itemController.addConstraint(heightConstraint)
//        }
        
//        editItemController = itemController
        
        // Item Navigation
//        let itemControlView = ItemControlView()
//        itemControlView.delegate = self
//        itemControlView.translatesAutoresizingMaskIntoConstraints = false
//
//        itemControlView.shadowType = .border(radius: 10, offset: CGSize(width: 5, height: 5))
//
//        itemControlView.secondButtonEnabled = true
//
//
//        itemControlView.addConstraint(NSLayoutConstraint.init(item: itemControlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64))
//
        itemViewStack.addArrangedSubview(itemController)
//        itemViewStack.addArrangedSubview(itemControlView)
//
        return itemViewStack
    }
        
    @objc private func cancelAction () {
        let error = NSError(domain: "com.justinlycklama.ThatLooksCool", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cancel Share"])
        extensionContext?.cancelRequest(withError: error)
    }
}

//extension ShareViewController: ItemIterationDelegate {
//    func didPressFirst() {
//        
//    }
//
//    func didPressThird() {
//
//    }
//
//    func didPressSecond() {
////        let categoriesViewController = DisplayCategoriesTableController()
////        categoriesViewController.delegate = self
////
////        self.present(categoriesViewController, animated: true, completion: nil)
//    }
//}

//extension ShareViewController: CompletableWithCategoryDelegate {
//    func complete(withCategory category: ItemCategory?) {
//        self.dismiss(animated: true, completion: { [weak self] in
//            guard let self = self else {
//                return
//            }
//
//            // Categorize item
//            RealmSubjects.shared.categorizeItem(self.mockItemCoordinator.saveItem(), toCategory: category)
//
//            // TODO: unpack url (ex. https://goo.gl/maps/WD3ZsR5zqGVgahcq8 ) using extension below and get new coordinates
//            // Update coordinates before completing
//
//            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
//        })
//    }
//}

extension URL {
    /** Request the http status of the URL resource by sending a "HEAD" request over the network. A nil response means an error occurred. */
       public func requestHTTPURL(completion: @escaping (_ fullURL: URL?) -> Void) {
           // Adapted from https://stackoverflow.com/a/35720670/7488171
           var request = URLRequest(url: self)
           request.httpMethod = "HEAD"
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let httpResponse = response as? HTTPURLResponse, error == nil {
                   completion(httpResponse.url)
               } else {
                   completion(nil)
               }
           }
           task.resume()
       }
}
