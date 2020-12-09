//
//  Category.swift
//  TLCModel
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import RealmSwift


import Foundation

public class ResolvedItemCategory: Object {

    @objc public dynamic var title: String

    public init(title: String) {
        self.title = title
    }
    
    required override init() {
        self.title = "<Undefined>"
    }
}
