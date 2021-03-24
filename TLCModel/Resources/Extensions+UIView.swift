//
//  Extensions+UIView.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-18.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    public func dismissKeyboard() {
        view.endEditing(true)
    }
}
