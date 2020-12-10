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
    public var pendingItemsSubject = BehaviorSubject<[PendingItem]>(value: [])
    
    // MARK: Resolved Items
    public var resolvedItemCategoriesSubject = BehaviorSubject<[ResolvedItemCategory]>(value: [])
    
    private var resolvedItemCategoriesCount = [ResolvedItemCategory : Int]()
    public var resolvedItemCategoriesCountSubject = BehaviorSubject<[ResolvedItemCategory : Int]>(value: [:])
    
    public var resolvedItemSubjectsByCategory = [ResolvedItemCategory : BehaviorSubject<[ResolvedItem]>]()
    
    private let realm: Realm
    
    private var tokenList = [NotificationToken]()
    private var categoryTokens = [ResolvedItemCategory : NotificationToken]()
    
    init() {

        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            fatalError()
        }
        
        /*
         Categories
         */
        let categories = realm.objects(ResolvedItemCategory.self)
        updateResolvedItemSubjects(for: categories.list())
        
        let categoriesToken = categories.observe { [weak self] (changes: RealmCollectionChange<Results<ResolvedItemCategory>>) in
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
        
        let pendingItems = realm.objects(PendingItem.self)
        
        let pendingToken = pendingItems.observe { [weak self] (changes: RealmCollectionChange<Results<PendingItem>>) in
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
    
    private func updateResolvedItemSubjects(for categories: [ResolvedItemCategory]) {
        // Add new categories to item Subjects
        for category in categories {
            if !self.resolvedItemSubjectsByCategory.keys.contains(category) {
                self.resolvedItemSubjectsByCategory[category] = BehaviorSubject<[ResolvedItem]>(value: [])
                
                let objectsInCategory = self.realm.objects(ResolvedItem.self).filter("category == %@", category)
                
                let token = objectsInCategory.observe { [weak self] (changes: RealmCollectionChange<Results<ResolvedItem>>) in
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
        
        let pendingItems = realm.objects(PendingItem.self)
        
        realm.beginWrite()
        realm.delete(pendingItems)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
    
    func addPendingItem(title: String) {
        let newItem = PendingItem(title: title)

        realm.beginWrite()
        realm.add(newItem)

        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
    
    func addCategory(title: String) {
        
        let newCategory = ResolvedItemCategory(title: title)
        
        realm.beginWrite()
        
        realm.add(newCategory)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
        
    }
    
    
    func removeCategory(_ category: ResolvedItemCategory) {
        realm.beginWrite()
        
        realm.delete(category)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
    }
    
    @discardableResult
    func categorize(item: PendingItem, as category: ResolvedItemCategory) -> ResolvedItem {
        
        let resolvedItem = ResolvedItem(pendingItem: item, category: category)
        
        realm.beginWrite()
        
        realm.delete(item)
        realm.add(resolvedItem)
        
        do {
            try realm.commitWrite()
        } catch {
            fatalError()
        }
        
        return resolvedItem
    }
    
    func uncategorize(item: ResolvedItem) {
        
        let pendingItem = PendingItem(resolvedItem: item)
        
        realm.beginWrite()
        
        realm.delete(item)
        realm.add(pendingItem)
        
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
