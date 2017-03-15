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
        switch personalRecord.resultType {
        case .weight:
            typeOfWorkout = "Weight:"
        case .repetitions:
            typeOfWorkout = "Repetition:"
        case .time:
            typeOfWorkout = "Time:"
        }
        
        if personalRecord.result == nil {
            contentLabel.text = typeOfWorkout
        } else {
            contentLabel.text = typeOfWorkout + " " + personalRecord.result!
        }
        
        rxLabel.isHidden = !personalRecord.rx
    }
}
