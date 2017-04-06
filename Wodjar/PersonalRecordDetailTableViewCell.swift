//
//  PersonalRecordDetailTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class PersonalRecordDetailTableViewCell: UITableViewCell {
    
    // @IBOutlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var rxLabel: UILabel!
    
    func populate(with personalRecord: PersonalRecord) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: personalRecord.date)
        
        var typeOfWorkout = String()
        typeOfWorkout = personalRecord.resultType.rawValue
        
        if let result = personalRecord.resultAsString() {
           contentLabel.text = typeOfWorkout + " " + result
        } else {
           contentLabel.text = typeOfWorkout
        }
        
        
        rxLabel.isHidden = !personalRecord.rx
    }
}
