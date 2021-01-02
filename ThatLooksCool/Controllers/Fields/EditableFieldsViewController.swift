//
//  EditMockItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-14.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

import TLCModel

enum Field {
    case shortText(title: String, initialValue: String?, onUpdate: ((String) -> Void))
    case longText(title: String, initialValue: String?, onUpdate: ((String) -> Void))
    case color(onUpdate: ((UIColor) -> Void))
    case map(coordinate: Coordinate)
}

class EditableFieldsViewController: UIViewController {

    struct Constants {
        static let ShortTextCell = "ShortTextCell"
        static let LongTextCell = "LongTextCell"
        static let ColorCell = "ColorCell"
        static let MapCell = "MapCell"
    }
        
    private let editItemsTable = UITableView()
    
    var fields: [Field] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        editItemsTable.register(UINib(nibName: "ShortStringCell", bundle: nil), forCellReuseIdentifier: Constants.ShortTextCell)
        editItemsTable.register(UINib(nibName: "LongStringCell", bundle: nil), forCellReuseIdentifier: Constants.LongTextCell)
        editItemsTable.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: Constants.ColorCell)
        editItemsTable.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: Constants.MapCell)
        
        editItemsTable.delegate = self
        editItemsTable.dataSource = self
        
        editItemsTable.tableFooterView = UIView()
        editItemsTable.separatorStyle = .none
        editItemsTable.isScrollEnabled = true
        editItemsTable.bounces = false
        editItemsTable.showsVerticalScrollIndicator = true
        editItemsTable.backgroundColor = .clear
        
        

        self.view.addSubview(editItemsTable)
        self.view.constrainSubviewToBounds(editItemsTable, withInset: UIEdgeInsets(top: TLCStyle.interiorMargin, left: 0, bottom: 0, right: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editItemsTable.flashScrollIndicators()
    }
    
    func addField(_ field: Field) {
        fields.append(field)
        editItemsTable.reloadData()
    }
    
    func removeAllFields() {
        fields.removeAll()
        editItemsTable.reloadData()
    }
}

extension EditableFieldsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        let field = fields[indexPath.row]
        
        switch field {
        case .shortText(let title, let initialValue, let onUpdate):
            let shortStringCell = tableView.dequeueReusableCell(withIdentifier: Constants.ShortTextCell, for: indexPath) as! ShortStringCell
            
            shortStringCell.title = title
            shortStringCell.initialValue = initialValue
            shortStringCell.onUpdate = onUpdate
            
            cell = shortStringCell
        case .longText(let title, let initialValue, let onUpdate):
            let longStringCell = tableView.dequeueReusableCell(withIdentifier: Constants.LongTextCell, for: indexPath) as! LongStringCell
            
            longStringCell.title = title
            longStringCell.initialValue = initialValue
            longStringCell.onUpdate = onUpdate
            
            cell = longStringCell
        case .color(let onUpdate):
            let colorCell = tableView.dequeueReusableCell(withIdentifier: Constants.ColorCell, for: indexPath) as! ColorCell
            
            colorCell.onUpdate = onUpdate
            
            cell = colorCell
        case .map(let coordinate):
            let mapCell = tableView.dequeueReusableCell(withIdentifier: Constants.MapCell, for: indexPath) as! MapCell

            mapCell.coordinate = coordinate
            
            cell = mapCell
        }
        
        return cell
    }
}
