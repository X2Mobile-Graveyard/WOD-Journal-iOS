//
//  WODResultTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODResultTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    func populate(with result: WODResult) {
        dateLabel.text = "Mar 03, 2017"
        resultLabel.text = "12:32"
    }
}
