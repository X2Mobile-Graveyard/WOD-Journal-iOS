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
    var records: [PersonalRecord] = [PersonalRecord]()
    var defaultResultType: WODCategory?
    
    init(name: String, present: Bool) {
        self.name = name
        self.present = present
    }
    
    init(name: String, present: Bool, defaultType: WODCategory) {
        self.name = name
        self.present = present
        self.defaultResultType = defaultType
    }
    
    func add(personalRecord: PersonalRecord) {
        records.append(personalRecord)
    }
}
