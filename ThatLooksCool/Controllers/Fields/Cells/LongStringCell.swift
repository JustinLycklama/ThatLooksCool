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
        
        selectionStyle = .none
        textView.delegate = self
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
