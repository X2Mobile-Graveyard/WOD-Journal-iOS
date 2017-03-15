//
//  PersonalRecordViewController+TimePicker.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

struct Time {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    func getFormatedString() -> String {
        if hours == 0 {
            return "\(minutes):\(seconds)"
        } else {
            return "\(hours):\(minutes):\(seconds)"
        }
    }
}

extension PersonalRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        }
        
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickedTimeFromTimePicker.hours = row
        } else if component == 1 {
            pickedTimeFromTimePicker.minutes = row
        } else {
            pickedTimeFromTimePicker.seconds = row
        }
    }
}
