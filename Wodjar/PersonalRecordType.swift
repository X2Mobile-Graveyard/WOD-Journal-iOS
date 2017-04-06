//
//  PersonalRecordType.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class PersonalRecordType {
    var name: String? = "Unknown"
    var present: Bool = false
    var records: [PersonalRecord] = [PersonalRecord]() {
        didSet {
            if records.count == 0 {
                self.present = false
            }
            
            if oldValue.count == 0 && records.count > 0 {
                self.present = true
            }
        }
    }
    var defaultResultType: WODCategory?
    var updatedAt: Date
    
    init(name: String, present: Bool, updatedAt: String?) {
        self.name = name
        self.present = present
        
        if updatedAt == nil {
            self.updatedAt = Date()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.updatedAt = dateFormatter.date(from: updatedAt!)!
    }
    
    init(name: String, present: Bool, defaultType: WODCategory, updatedAt: String?) {
        self.name = name
        self.present = present
        self.defaultResultType = defaultType
        
        if updatedAt == nil {
            self.updatedAt = Date()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.updatedAt = dateFormatter.date(from: updatedAt!)!
    }
    
    init(with dict: [String: String]) {
        if let date = dict["updated_at"] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            self.updatedAt = dateFormatter.date(from: date)!
        } else {
            self.updatedAt = Date()
        }
        
        if let name = dict["name"] {
            self.name = name
        } else {
            self.name = "unknown"
        }
        
        self.defaultResultType = .weight
        self.present = true
    }
    
    func add(personalRecord: PersonalRecord) {
        records.append(personalRecord)
    }
}
