//
//  PersonalRecord.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/9/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class PersonalRecord {
    var id: Int?
    var name: String? = nil
    var rx: Bool = false
    var result: String? = nil
    var resultType: WODCategory = .weight
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
        case .amrap:
            return "Repetition completed"
        default:
            return "Unknown"
        }
    }
    var notes: String? = nil
    var imageUrl: String? = nil
    var date: Date = Date()
    
    
    convenience init(name: String?,
         rx: Bool,
         result: String?,
         resultType: WODCategory,
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
    
    convenience init(personalRecord: PersonalRecord) {
        self.init()
        self.id = personalRecord.id
        self.name = personalRecord.name
        self.rx = personalRecord.rx
        self.result = personalRecord.result
        self.resultType = personalRecord.resultType
        self.date = personalRecord.date
        self.unitType = personalRecord.unitType
        self.notes = personalRecord.notes
        self.imageUrl = personalRecord.imageUrl
        self.date = personalRecord.date
    }
    
    func updateValues(from personalRecord: PersonalRecord) {
        self.id = personalRecord.id
        self.name = personalRecord.name
        self.rx = personalRecord.rx
        self.result = personalRecord.result
        self.resultType = personalRecord.resultType
        self.date = personalRecord.date
        self.unitType = personalRecord.unitType
        self.notes = personalRecord.notes
        self.imageUrl = personalRecord.imageUrl
        self.date = personalRecord.date
    }
}
