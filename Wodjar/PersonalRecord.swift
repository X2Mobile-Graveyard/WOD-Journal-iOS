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
    var updatedAt: Date? = nil
    
    convenience init(with dictionary: [String: Any]) {
        self.init()
        
        self.id = dictionary["id"] as? Int ?? nil
        self.name = dictionary["name"] as? String ?? nil
        self.rx = dictionary["ex"] as? Bool ?? false
        self.result = dictionary["result"] as? String ?? nil
        if let resultTypeInt = dictionary["result_type"] as? Int {
            self.resultType = WODCategory.from(hashValue: resultTypeInt)
        }
        if let unitTypeInt = dictionary["unit_type"] as? Int {
            self.unitType = UnitType(rawValue: unitTypeInt)!
        }
        self.notes = dictionary["notes"] as? String ?? nil
        self.imageUrl = dictionary["image_url"] as? String ?? nil
        if let lastUpdate = dictionary["updated_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            self.updatedAt = dateFormatter.date(from: lastUpdate)
        } else {
            self.updatedAt = nil
        }
    }
    
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
    
    func createUpdateDict() -> [String: Any] {
        var updateDict = [String: Any]()
        
        updateDict["name"] = self.name!
        updateDict["rx"] = self.rx
        updateDict["result"] = self.result!
        updateDict["result_type"] = self.resultType.hash()
        updateDict["unit_type"] = self.unitType.hashValue
        if let notes = self.notes {
            updateDict["notes"] = notes
        }
        
        if let url = imageUrl {
            updateDict["image_url"] = url
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        updateDict["date"] = dateFormatter.string(from: self.date)
        
        return updateDict
    }
}
