//
//  WODDescriptionTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    func populate(with wodDescription: String, for type: WODType, editMode: Bool, toolbar: UIToolbar?) {
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        
        textView.text = wodDescription
        textView.isEditable = false
        if type == .custom && editMode {
            textView.isEditable = true
        }
        
        if toolbar != nil {
            textView.inputAccessoryView = toolbar
        }
    }
}
