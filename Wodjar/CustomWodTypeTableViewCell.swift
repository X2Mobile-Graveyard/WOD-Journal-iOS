//
//  CustomWodTypeTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit


class CustomWodTypeTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func populate(with wod: Workout) {
        dateLabel.text = wod.date?.getMonthAndDay()
        if let bestRecord = wod.bestResult {
            recordLabel.text = bestRecord
        } else {
            recordLabel.text = ""
        }
        
        if wod.unit == .imperial {
            descriptionLabel.text = wod.wodDescription!
        } else {
            descriptionLabel.text = wod.metricDescription ?? wod.wodDescription
        }
    }
}
