//
//  ResolvedItemsViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-06.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit
import RxSwift

import TLCModel

class ResolvedItemsViewController: UIViewController {

    let category: ItemCategory
    var resolvedItems = [Item]()
    
    let disposeBag = DisposeBag()
    
    private let tableview = UITableView()
    
    init(category: ItemCategory) {
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        
        self.view.addSubview(tableview)
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "ANY")
        
        tableview.delegate = self
        tableview.dataSource = self
        
        RealmSubjects.shared.resolvedItemSubjectsByCategory[category]?.subscribe(
            onNext: { [weak self] (itemList: [Item]) in
                self?.resolvedItems = itemList
                self?.tableview.reloadData()
                
        }, onError: { (err: Error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
}

extension ResolvedItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resolvedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ANY", for: indexPath)
        
        cell.textLabel?.text = resolvedItems[indexPath.row].title
        
        return cell
    }
    
    
}
