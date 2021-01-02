//
//  ShortStringCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-15.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class ShortStringCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueTextField: UITextField!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var initialValue: String? = nil {
        didSet {
            valueTextField.text = initialValue
        }
    }
    
    var onUpdate: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueTextField.layer.cornerRadius = TLCStyle.textCornerRadius
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.borderColor = TLCStyle.textBorderColor.cgColor
        
        selectionStyle = .none
        valueTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func textFieldDidChange(textField: UITextField) {
        onUpdate?(textField.text ?? "")
    }
}
