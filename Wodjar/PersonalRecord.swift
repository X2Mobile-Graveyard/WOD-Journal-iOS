//
//  PersonalRecord.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/9/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

enum PersonalRecordResultType {
    case weight
    case repetitions
    case time
}

enum UnitType {
    case imperial
    case metric
}

class PersonalRecord {
    var name: String? = nil
    var rx: Bool = false
    var result: String? = nil
    var resultType: PersonalRecordResultType = .weight
    var unitType: UnitType = .metric
    var measurementUnit: String {
        switch resultType {
        case .weight:
            if unitType == .imperial {
                return "Weight Lifted (lb)"
            } else {
                return "Weight Lifted (Kg)"
            }
        case .time:
            return "Time (mm:ss)"
        case .repetitions:
            return "Repetition completed"
        }
    }
    var notes: String? = nil
    var imageUrl: String? = nil
    var date: Date = Date()
    
    
    convenience init(name: String?,
         rx: Bool,
         result: String?,
         resultType: PersonalRecordResultType,
         unitType: UnitType,
         notes: String?,
         imageUrl: String?,
         date: Date) {
        
        self.init()
        self.name = name
        self.rx = rx
        self.result = result
        self.resultType = resultType
        self.unitType = unitType
        self.notes = notes
        self.imageUrl = imageUrl
        self.date = date
    }
}
