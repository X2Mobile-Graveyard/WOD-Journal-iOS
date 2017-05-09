//
//  PersonalRecordType.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class PersonalRecordType: NSObject {
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
    
    init(with dict: [String: Any]) {
        if let date = dict["updated_at"] as? String {
            self.updatedAt = date.getDateFromWodJournalFormatStyle()
        } else {
            self.updatedAt = Date()
        }
        
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = "unknown"
        }
        
        if let present = dict["present"] as? Bool {
            self.present = present
        } else {
            self.present = false
        }
        
        if let type = dict["result_type"] as? Int {
            self.defaultResultType = WODCategory.from(hashValue: type)
        } else {
            self.defaultResultType = .weight
        }
    }
    
    func add(personalRecord: PersonalRecord) {
        records.append(personalRecord)
    }
}
