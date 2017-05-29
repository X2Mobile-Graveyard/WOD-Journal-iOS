//
//  MoreSimpleTextTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/18/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreSimpleTextTableViewCell: UITableViewCell {

    @IBOutlet var simpleTextLabel: UILabel!

    func populate(with text: String) {
        simpleTextLabel.text = text
    }

}
