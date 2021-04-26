//
//  UnResolvedItemModel.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-18.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift

// Encapsulate Realm in this file, to not become dependant on one type of database
public enum DatabaseObservation<CollectionType: RealmCollectionValue> {
    case initial([CollectionType])
    case update([CollectionType], deletions: [Int], insertions: [Int], modifications: [Int])
    case error(Error)
}

fileprivate extension DatabaseObservation {
    init(realmChange: RealmCollectionChange<Results<CollectionType>>)  {
        switch realmChange {
        case .initial(let results):
            self = .initial(results.list())
        case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
            self = .update(results.list(), deletions: deletions, insertions: insertions, modifications: modifications)
        case .error(let error):
            self = .error(error)
        }
    }
}

fileprivate class Database {
    fileprivate static let shared = Database()
    
    private var tokenList = [NotificationToken]()
    
    private var realm: Realm? {
        get {
            do {
                let realm = try Realm(configuration: TLC_Constants.realmConfig)
                return realm
            } catch (let error) {
                print("---")
                print("Couldn't get Realm Database from config: \(error.localizedDescription)")
                print("---")
                
                return nil
            }
        }
    }
    
    deinit {
        for token in tokenList {
            token.invalidate()
        }
    }
    
    @discardableResult
    func add(object: Object) -> Bool {
        do {
            try realm?.write {
                realm?.add(object)
            }
            return true
        } catch (let error) {
            print("Couldn't write to database: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(_ modification:(() -> Void)) -> Bool {
        do {
            try realm?.write {
                modification()
            }
            return true
        } catch (let error) {
            print("Couldn't write to database: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func remove(object: Object) -> Bool {
        do {
            try realm?.write {
                realm?.delete(object)
            }
            return true
        } catch (let error) {
            print("Couldn't delete from database: \(error.localizedDescription)")
            return false
        }
    }
    
    func observe<T: Object>(_ filterString: String, _ filterObject: Object? = nil, onUpdate: @escaping (DatabaseObservation<T>) -> Void) {
        let results: Results<T>?
        if let obj = filterObject {
            results = realm?.objects(T.self).filter(filterString, obj)
        } else {
            results = realm?.objects(T.self).filter(filterString)
        }
        
        if let objectSubset = results {
            let token = objectSubset.observe(on: .main) { (changes: RealmCollectionChange<Results<T>>) in
                onUpdate(DatabaseObservation(realmChange: changes))
            }
            
            tokenList.append(token)
        } else {
            print("Couldn't observe on database using filter: \(filterString)")
        }
    }
}

public class DatabaseListener {
    public static let shared = DatabaseListener()

    // MARK: Item
//    public var newItems = BehaviorSubject<[Item]>(value: [])

//    private var itemSubjectByCategory = [ItemCategory : BehaviorSubject<[Item]>]()
//    func items(by category: ItemCategory? = nil) {
//
//    }
    
    
    // MARK: ItemCategory
    public var itemCategories = BehaviorSubject<[ItemCategory]>(value: [])
    
    
    init() {
        createNewItemSubjects()
//        createPendingItemSubjects()
//        createResolvedItemSubjects()
    }
    
    public func newItems(onUpdate: @escaping (DatabaseObservation<Item>) -> Void) {
        Database.shared.observe("category == nil", onUpdate: onUpdate)
    }
    
    public func items(by category: ItemCategory, onUpdate: @escaping (DatabaseObservation<Item>) -> Void) {
        Database.shared.observe("category == %@", category, onUpdate: onUpdate)
    }
    
    private func createNewItemSubjects() {
//        Database.shared.observe("category == nil") { (observation: DatabaseObservation<Item>) in
//            switch observation {
//            case .initial(let newItems):
//
//            case .update(let newItems, deletions: let deletions, insertions: let insertions, modifications: let modifications):
//
//            case .error(_):
//                break
//            }
//        }
    }
}

public class RealmSubjects {
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
    
    public var recentlyResolvedItems = BehaviorSubject<[Item]>(value: [])
    
    private let realm: Realm
    
    private var tokenList = [NotificationToken]()
    private var categoryTokens = [ItemCategory : NotificationToken]()
    
    init() {

        do {
            realm = try Realm(configuration: TLC_Constants.realmConfig)
        } catch {
            fatalError()
        }
        
        createCategorySubjects()
        createPendingItemSubjects()
        createResolvedItemSubjects()
    }
    
    deinit {
        for token in tokenList {
            token.invalidate()
        }
    }
    
    // MARK: - Subject Helpers
    
    private func createCategorySubjects() {
        let categories = realm.objects(ItemCategory.self)
        updateResolvedItemSubjects(for: categories.list())
        
        let categoriesToken = categories.observe(on: .main) { [weak self] (changes: RealmCollectionChange<Results<ItemCategory>>) in
            guard let self = self else {
                fatalError()
            }

            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    let categories = results.list()
//                    self.updateResolvedItemSubjects(for: categories)
                    
                    self.resolvedItemCategoriesSubject.onNext(categories)
                }
            case .error:
                break
            }
        }
        
        tokenList.append(categoriesToken)
    }
    
    /// Pending items are Items with no category
    private func createPendingItemSubjects() {
        let pendingItems = realm.objects(Item.self).filter("category == nil")
        
        let pendingToken = pendingItems.observe(on: .main) { [weak self] (changes: RealmCollectionChange<Results<Item>>) in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                DispatchQueue.main.async {
                    self?.pendingItemsSubject.onNext(results.list())
                    self?.pendingItemCountSubject.onNext(results.count)
                }
                
                UIApplication.shared.applicationIconBadgeNumber = results.count
            case .error:
                break
   
            }
        }
        
        tokenList.append(pendingToken)
    }
    
    private func createResolvedItemSubjects() {
        let resolvedItems = realm.objects(Item.self).filter("category != nil")
        
        let token = resolvedItems.observe(on: .main) { [weak self] (changes: RealmCollectionChange<Results<Item>>) in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                let sorted = results.sorted(by: { (a: Item, b: Item) -> Bool in
                    a.timestamp ?? Date() > b.timestamp ?? Date()
                })
                
                DispatchQueue.main.async {
                    self?.recentlyResolvedItems.onNext(sorted)
                }
            case .error:
                break
            }
        }
        
        tokenList.append(token)
    }
    
    /// Resolved Items are items that have a category
    private func updateResolvedItemSubjects(for categories: [ItemCategory]) {
        // Add new categories to item Subjects
        for category in categories {
            if !self.resolvedItemSubjectsByCategory.keys.contains(category) {
                self.resolvedItemSubjectsByCategory[category] = BehaviorSubject<[Item]>(value: [])
                
                let objectsInCategory = self.realm.objects(Item.self).filter("category == %@", category)
                
                let token = objectsInCategory.observe(on: .main) { [weak self] (changes: RealmCollectionChange<Results<Item>>) in
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
    
    // MARK: - Item
    
    
    // Item to be filled in from external share extent. Should only be one active at a time
    public func setOutItem(item: Item) {
        
        do {
            try realm.write {
                realm.objects(Item.self).filter("isSelectedOutItem == true").forEach { (oldSelection: Item) in
                    oldSelection.isSelectedOutItem = false
                }
                
                item.isSelectedOutItem = true
            }
        } catch {
            fatalError()
        }
    }
    
//    // TODO remove
//    public func addPendingItem(title: String) {
//        let newItem = Item(title: title)
//
//        realm.beginWrite()
//        realm.add(newItem)
//
//        do {
//            try realm.commitWrite()
//        } catch {
//            fatalError()
//        }
//    }
//    
//    // TODO remove
//    public func addPendingItem() {
//        let coordinate = Coordinate(coreLocationCoordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(43.6331596), longitude: CLLocationDegrees(-79.4141207)))
//        let newItem = Item(coordinate: coordinate)
//
//        realm.beginWrite()
//        realm.add(newItem)
//
//        do {
//            try realm.commitWrite()
//        } catch {
//            fatalError()
//        }
//    }
    

    
//    public func removeAllPendingItems() {
//
//        let pendingItems = realm.objects(Item.self)
//
//        realm.beginWrite()
//        realm.delete(pendingItems)
//
//        do {
//            try realm.commitWrite()
//        } catch {
//            fatalError()
//        }
//    }
    
    // MARK: - Category
    
//    public func setupCategoriesIfNone() {
//        let categories = realm.objects(ItemCategory.self)
//
//        if (categories.count == 0) {
//            do {
//                let takeout = MockCategory(category: nil)
//                takeout.title = "Takeout"
//
//                let bars = MockCategory(category: nil)
//                bars.title = "Bars"
//
//                try realm.write {
//                    realm.add(ItemCategory(mock: takeout))
//                    realm.add(ItemCategory(mock: bars))
//                }
//            } catch {
//                fatalError()
//            }
//        }
//    }
}

extension ItemCategory {
    @discardableResult
    public static func create(withMock mock: MockCategory) -> ItemCategory? {
        let category = ItemCategory(mock: mock)
        return Database.shared.add(object: category) ? category : nil
    }

    @discardableResult
    public func update(usingMock mock: MockCategory) -> ItemCategory {
        Database.shared.update {
            self.title = mock.title
            self.color = mock.color
            self.icon = mock.icon
        }
        
        return self
    }
    
    public func remove() {
        Database.shared.remove(object: self)
    }
}

extension Item {
    @discardableResult
    public static func create(withMock mock: MockItem, toCategory category: ItemCategory?) -> Item? {
        let item = Item(mock: mock, category: category)
        return Database.shared.add(object: item) ? item : nil
    }
    
    public func update(usingMock mock: MockItem) {
        Database.shared.update {
            self.title = mock.title
            self.info = mock.info
            self.coordinate = mock.coordinate
        }
    }
    
    public func categorize(toCategory category: ItemCategory?) {
        Database.shared.update {
            self.category = category
        }
    }
    
    public func remove() {
        Database.shared.remove(object: self)
    }
}

// .list function must be called from the thread we are planning to use it
// If we create the list on a background thread and then wait until the main thread to use it, the objects in the list could be invalidated
public extension Results {
    func list() -> [Element] {
        return Array(self)
    }
 }

