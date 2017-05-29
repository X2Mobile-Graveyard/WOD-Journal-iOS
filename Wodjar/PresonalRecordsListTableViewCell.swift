//
//  PresonalRecordsListTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class PresonalRecordsListTableViewCell: UITableViewCell {
    
    // @IBOutlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!

    func populate(with name: String, bestRecord: String?) {
        nameLabel.text = name
        if bestRecord != nil {
            recordLabel.text = bestRecord
        } else {
            recordLabel.text = ""
        }
    }
}
