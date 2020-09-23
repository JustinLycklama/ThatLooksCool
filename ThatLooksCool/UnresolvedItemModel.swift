//
//  UnResolvedItemModel.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-18.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Foundation

import TLCModel
import RealmSwift
import RxRealm
import RxSwift

class UnresolvedItemModel {
    public static let sharedInstance = UnresolvedItemModel()
    
    // A behavior subject will give any subscriber the most recent element and everything that is emitted by that sequence after the subscription happened.
    public var unresolvedItemCountSubject = BehaviorSubject<Int>(value: 0)
    
    public var unresolvedItemsSubject = BehaviorSubject<[UnresolvedLocation]>(value: [])

    
    private var disposeBag: DisposeBag
    
    init() {
        let realm: Realm!
            
        do {
            realm = try! Realm(configuration: TLC_Constants.realmConfig)
        }
        
        disposeBag = DisposeBag()
        
        
        let unresolvedLocations = realm.objects(UnresolvedLocation.self)
        
        Observable.collection(from: unresolvedLocations)
            .subscribe(onNext: { [weak self] (results: Results<UnresolvedLocation>) in
                
                self?.unresolvedItemCountSubject.onNext(results.count)
                UIApplication.shared.applicationIconBadgeNumber = results.count

                self?.unresolvedItemsSubject.onNext(results.toArray())
                                            
            }, onError: { (err: Error) in
                
            }, onCompleted: {
                
            }) {
        }.disposed(by: disposeBag)
                

    }
    
}
