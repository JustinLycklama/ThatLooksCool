//
//  EditMockItemViewController.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-14.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

public enum Field {
    case shortText(title: String, initialValue: String?, onUpdate: ((String) -> Void))
    case longText(title: String, initialValue: String?, onUpdate: ((String) -> Void))
    case color(onUpdate: ((UIColor) -> Void))
    case map(coordinate: Coordinate)
    case list(title: String, values: [String])
}

protocol ExternalApplicationRequestDelegate: AnyObject {
    func requestMapApplication(forCoordinate coordinate: Coordinate)
}

public class EditableFieldsViewController: UIViewController {

    struct Constants {
        static let ShortTextCell = "ShortTextCell"
        static let LongTextCell = "LongTextCell"
        static let ColorCell = "ColorCell"
        static let MapCell = "MapCell"
        static let ListCell = "ListCell"
    }
        
    private let editItemsTable = UITableView()
    
    public var sizeSubscriber: ((CGSize) -> Void)? {
        didSet {
            completeFieldSetup()
        }
    }
    
    var fields: [Field] = []
    
    internal weak var delegate: ExternalApplicationRequestDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        editItemsTable.register(ShortStringCell.self, forCellReuseIdentifier: Constants.ShortTextCell)
        editItemsTable.register(LongStringCell.self, forCellReuseIdentifier: Constants.LongTextCell)
        editItemsTable.register(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: Constants.ColorCell)
        editItemsTable.register(MapCell.self, forCellReuseIdentifier: Constants.MapCell)
        editItemsTable.register(ListCell.self, forCellReuseIdentifier: Constants.ListCell)
        
        editItemsTable.delegate = self
        editItemsTable.dataSource = self
        
        editItemsTable.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: TLCStyle.topLevelPadding)))
        editItemsTable.separatorStyle = .none
        editItemsTable.isScrollEnabled = true
        editItemsTable.bounces = false
        editItemsTable.showsVerticalScrollIndicator = true
        editItemsTable.sectionHeaderHeight = TLCStyle.interiorMargin
        editItemsTable.backgroundColor = .clear
        
        self.view.addSubview(editItemsTable)
        self.view.constrainSubviewToBounds(editItemsTable)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editItemsTable.flashScrollIndicators()
    }
    
    public func addField(_ field: Field) {
        fields.append(field)
        editItemsTable.reloadData()
    }
    
    public func removeAllFields() {
        fields.removeAll()
        editItemsTable.reloadData()
    }
    
    public func completeFieldSetup() {
        if let subscriber = sizeSubscriber {
            self.view.layoutIfNeeded()
            subscriber(editItemsTable.contentSize)
        }
    }
}

extension EditableFieldsViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            mapCell.delegate = self
            
            cell = mapCell
        case .list(let title, let values):
            let listCell = tableView.dequeueReusableCell(withIdentifier: Constants.ListCell, for: indexPath) as! ListCell

            listCell.title = title
            listCell.items = values
            
            cell = listCell
            
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension EditableFieldsViewController: ExternalApplicationRequestDelegate {
    func requestMapApplication(forCoordinate coordinate: Coordinate) {
        self.delegate?.requestMapApplication(forCoordinate: coordinate)
    }
}
