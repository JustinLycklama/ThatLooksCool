//
//  LongStringCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LongStringCell: UITableViewCell {

//    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var borderView: UIView!
    
    let placeholderLabel = UILabel()
    
    var title: String = "" {
        didSet {
            placeholderLabel.text = title
        }
    }
    
    var initialValue: String? = nil {
        didSet {
            textView.text = initialValue
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    var onUpdate: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        textView.style(.userText)
        
        textView.delegate = self
        
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.style(.label)
        placeholderLabel.sizeToFit()
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = TLCStyle.placeholderTextColor
        placeholderLabel.isHidden = !textView.text.isEmpty
        
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
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText:String = textView.text
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
//
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        }
//
//        // Else if the text view's placeholder is showing and the
//        // length of the replacement string is greater than 0, set
//        // the text color to black then set its text to the
//        // replacement string
//         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.textColor = UIColor.black
//            textView.text = text
//        }
//
//        // For every other case, the text should change with the usual
//        // behavior...
//        else {
//            return true
//        }
//
//        // ...otherwise return false since the updates have already
//        // been made
//        return false
//    }
//
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        if self.window != nil {
//            if textView.textColor == UIColor.lightGray {
//                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//            }
//        }
//    }
}
