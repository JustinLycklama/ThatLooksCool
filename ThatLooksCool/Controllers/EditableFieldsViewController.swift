//
//  EditMockItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-14.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

enum FieldType {
    case shortText(initialValue: String, onUpdate: ((String) -> Void))
    case color(onUpdate: ((UIColor) -> Void))
}

struct Field {
    var title: String
    var type: FieldType
}

class EditableFieldsViewController: UIViewController {

    struct Constants {
        static let ShortTextCell = "ShortTextCell"
        static let ColorCell = "ColorCell"
    }
        
    private let editItemsTable = UITableView()
    
    var fields: [Field] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editItemsTable.register(UINib(nibName: "ShortStringCell", bundle: nil), forCellReuseIdentifier: Constants.ShortTextCell)
        editItemsTable.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: Constants.ColorCell)
        
        editItemsTable.delegate = self
        editItemsTable.dataSource = self
        
        editItemsTable.tableFooterView = UIView()
        editItemsTable.separatorStyle = .none
        editItemsTable.isScrollEnabled = false
        editItemsTable.backgroundColor = .clear

        self.view.addSubview(editItemsTable)
        self.view.constrainSubviewToBounds(editItemsTable)
    }
    
    func addField(field: Field) {
        fields.append(field)
        
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
        
        switch field.type {
        case .shortText(let initialValue, let onUpdate):
            let shortStringCell = tableView.dequeueReusableCell(withIdentifier: Constants.ShortTextCell, for: indexPath) as! ShortStringCell
            
            shortStringCell.title = field.title
            shortStringCell.initialValue = initialValue
            shortStringCell.onUpdate = onUpdate
            
            cell = shortStringCell
        case .color(let onUpdate):
            let colorCell = tableView.dequeueReusableCell(withIdentifier: Constants.ColorCell, for: indexPath) as! ColorCell
            
            colorCell.onUpdate = onUpdate
            
            cell = colorCell
        }
        
        return cell
    }
}
