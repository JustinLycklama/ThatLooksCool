//
//  ColorCell.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-12-16.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet var colorPicker: HSBColorPicker!
        
    var onUpdate: ((UIColor) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        colorPicker.delegate = self        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ColorCell: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        onUpdate?(color)
    }
}
