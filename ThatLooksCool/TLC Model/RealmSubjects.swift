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
import RxSwift

class RealmSubjects {
    public static let shared = RealmSubjects()
    
    // A behavior subject will give any subscriber the most recent element and everything that is emitted by that sequence after the subscription happened.
    
    // MARK: Unresolved Items
    public var pendingItemCountSubject = BehaviorSubject<Int>(value: 0)
    public var pendingItemsSubject = BehaviorSubject<[Item]>(value: [])
    
    // MARK: Resolved Items
    public var resolvedItemCategoriesSubject = BehaviorSubject<[ItemCategory]>(value: [])
    
    private var resolvedItemCategoriesCount = [ItemCategory : Int]()
    public var resolvedItemCategoriesCountSubject = BehaviorSubject<[ItemCategory : Int]>(value: [:])
    
    public var resolvedItemSubjectsByCategory = [ItemCategory : BehaviorSubject<[Item]>]()
    
    private let realm: Realm
    
    private var tokenList = [NotificationToken]()
    private var categoryTokens = [ItemCategory : NotificationToken]()
    
    init() {

        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            fatalError()
        }
        
        /*
         Categories
         */
        let categories = realm.objects(ItemCategory.self)
        updateResolvedItemSubjects(for: categories.list())
        
        let categoriesToken = categories.observe { [weak self] (changes: RealmCollectionChange<Results<ItemCategory>>) in
            guard let self = self else {
                fatalError()
            }

            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    let categories = results.list()
                    self.updateResolvedItemSubjects(for: categories)
                    
                    self.resolvedItemCategoriesSubject.onNext(categories)
                }
            case .error:
                break
            }
        }
        
        tokenList.append(categoriesToken)
        
        /*
         Pending Items
         */
        
        let pendingItems = realm.objects(Item.self).filter("category == nil")
        
        let pendingToken = pendingItems.observe { [weak self] (changes: RealmCollectionChange<Results<Item>>) in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    self?.pendingItemsSubject.onNext(results.list())
                }
            case .error:
                break
   
            }
        }
        
        tokenList.append(pendingToken)
        
        /*
         Resolved Items
         */
        
        
        
    }
    
    deinit {
        for token in tokenList {
            token.invalidate()
        }
    }
    
    private func updateResolvedItemSubjects(for categories: [ItemCategory]) {
        // Add new categories to item Subjects
        for category in categories {
            if !self.resolvedItemSubjectsByCategory.keys.contains(category) {
                self.resolvedItemSubjectsByCategory[category] = BehaviorSubject<[Item]>(value: [])
                
                let objectsInCategory = self.realm.objects(Item.self).filter("category == %@", category)
                
                let token = objectsInCategory.observe { [weak self] (changes: RealmCollectionChange<Results<Item>>) in
                    guard let self = self else {
                        fatalError()
                    }
                    
                    switch changes {
                    case .initial(let results), .update(let results, _, _, _):
                        DispatchQueue.main.async {
                            self.resolvedItemCategoriesCount[category] = (self.resolvedItemCategoriesCount[category] ?? 0) + 1
                            self.resolvedItemCategoriesCountSubject.onNext(self.resolvedItemCategoriesCount)
                            self.resolvedItemSubjectsByCategory[category]?.onNext(results.list())
                        }
                    case .error:
                        break
           
                    }
                }
                
                self.categoryTokens[category] = token
            }
        }
        
        // Remove old category from item Subjects
        for key in self.resolvedItemSubjectsByCategory.keys {
            if !categories.contains(key) {
                self.resolvedItemCategoriesCount[key] = 0
                
                self.resolvedItemSubjectsByCategory[key]?.onCompleted()
                self.resolvedItemSubjectsByCategory[key]?.dispose()
                self.resolvedItemSubjectsByCategory[key] = nil
                
                self.categoryTokens[key]?.invalidate()
            }
        }
    }
    
    func removeAllPendingItems() {
        
        let pendingItems = realm.objects(Item.self)
        
        realm.beginWrite()
        realm.delete(pendingItems)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
    
    func addPendingItem(title: String) {
        let newItem = Item(title: title)

        realm.beginWrite()
        realm.add(newItem)

        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
    
    func addCategory(withMock mock: MockCategory) {
        do {
            try realm.write {
                realm.add(ItemCategory(mock: mock))
            }
        } catch {
            fatalError()
        }        
    }
    
    func updateCategory(category: ItemCategory, usingMock mock: MockCategory) {
        do {
            try realm.write {
                category.update(usingMock: mock)
            }
        } catch {
            fatalError()
        }
    }
    
    func removeCategory(_ category: ItemCategory) {
        realm.beginWrite()
        
        realm.delete(category)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
}

// .list function must be called from the thread we are planning to use it
// If we create the list on a background thread and then wait until the main thread to use it, the objects in the list could be invalidated
extension Results {
    func list() -> [Element] {
        return Array(self)
    }
 }
