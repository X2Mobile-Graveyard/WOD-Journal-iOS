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
    
    func populate(with wodDescription: String) {
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        textView.text = wodDescription
    }

}
