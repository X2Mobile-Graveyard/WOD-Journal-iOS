//
//  MoreUnitTypeTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/26/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreUnitTypeTableViewCell: UITableViewCell {

    @IBOutlet var segmentControl: UISegmentedControl!
    
    func populate() {
        segmentControl.selectedSegmentIndex = UserManager.sharedInstance.unitType.rawValue
    }
}
