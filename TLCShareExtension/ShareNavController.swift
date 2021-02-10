//
//  ShareNavController.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2020-12-04.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import TLCModel

@objc(ShareNavController)
class ShareNavController: UINavigationController {

    let destinationChoiceController = ItemDestinationViewController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // Configure for Maps use
        // TLCConfig.configure()
        
        self.setViewControllers([destinationChoiceController], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
