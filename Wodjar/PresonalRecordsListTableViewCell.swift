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
    @IBOutlet var presentView: UIView!

    func populate(with name: String, present: Bool) {
        presentView.isHidden = !present
        presentView.layer.cornerRadius = presentView.frame.size.height / 2
        presentView.layer.masksToBounds = true
        nameLabel.text = name
    }

}
