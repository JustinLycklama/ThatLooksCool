//
//  LongStringCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LongStringCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var borderView: UIView!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var initialValue: String? = nil {
        didSet {
            textView.text = initialValue
        }
    }
    
    var onUpdate: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.style(.label)
        textView.style(.userText)
        
        selectionStyle = .none
        textView.delegate = self
        
        borderView.layer.cornerRadius = TLCStyle.textCornerRadius
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = TLCStyle.textBorderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension LongStringCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onUpdate?(textView.text ?? "")
    }
}
