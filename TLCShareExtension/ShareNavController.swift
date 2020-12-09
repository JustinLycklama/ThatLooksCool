//
//  ShareNavController.swift
//  TLCShareExtension
//
//  Created by Justin Lycklama on 2020-12-04.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

@objc(ShareNavController)
class ShareNavController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 2: set the ViewControllers
        self.setViewControllers([ShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
