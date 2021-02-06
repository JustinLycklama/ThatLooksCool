//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-16.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

//
//  EditItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-12.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import ClassicClient

public class ModifiableFormView: FormView {

//    private let associatedCategory: ItemCategory?
//
//    private let databaseObject: Item?
//    private let mockObject: MockItem
//
//    public weak var completeDelegate: CompletableActionDelegate?
    
//    private var formController: FormView?
    private let displaysMap: Bool
    
//    public override var intrinsicContentSize: CGSize {
//        return formController?.intrinsicContentSize ?? .zero
//    }
    
    public var sizeSubscriber: ((CGSize) -> Void)? {
        didSet {
//            formController?.sizeSubscriber = sizeSubscriber
        }
    }
    
    public init(item: Item?, category: ItemCategory?, displaysMap: Bool = true) {
        mockObject = MockItem(item: item)
        databaseObject = item
        associatedCategory = category
        self.displaysMap = displaysMap
        
        
        super.init(fields: mockObject.itemFields())
    }
    
    public init(item: Item?, mockItem: MockItem, category: ItemCategory?, displaysMap: Bool = false) {
        mockObject = mockItem
        databaseObject = item
        associatedCategory = category
        self.displaysMap = displaysMap
        
        super.init(fields: mockObject.itemFields())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ModifiableFormView {
    func requestMapApplication(forCoordinate coordinate: Coordinate) {
        
        if let item = databaseObject {
            RealmSubjects.shared.setOutItem(item: item)
        }
        
        let lat = coordinate.coreLocationCoordinate.latitude
        let lon = coordinate.coreLocationCoordinate.longitude
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            print("Cannot open maps")
            
            if let urlDestination = URL.init(string: "https://www.google.com/maps/?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)"){
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }
}

