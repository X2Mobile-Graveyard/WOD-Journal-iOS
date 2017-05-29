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
    var unitType: UnitType {
        return UserManager.sharedInstance.unitType
    }
    public private(set) var _bestResultWeight: Float?
    var bestResultWeight: Float? {
        set {
            self._bestResultWeight = newValue
        }
        
        get {
            if self.unitType == .imperial {
                return self._bestResultWeight?.convertToImperial()
            }
            
            return self._bestResultWeight
        }
    }
    var bestResultTime: Int?
    var bestResultRounds: Int?
    var bestResult: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 2
        switch defaultResultType! {
        case .weight:
            if bestResultWeight != nil {
                let resultNumber = NSNumber(value: bestResultWeight!)
                if unitType == .imperial {
                    return "Weight: \(numberFormatter.string(from: resultNumber)!) lbs"
                } else {
                     return "Weight: \(numberFormatter.string(from: resultNumber)!) kg"
                }
            }
            return nil
        case .amrap:
            if bestResultRounds != nil {
                return "Rounds: \(bestResultRounds!)"
            }
            return nil
        case .time:
            if bestResultTime != nil {
                let timeString = timeAsString()
                return timeString == "00:00" ? nil : "Time: \(timeString)"
            }
            return nil
        default:
            break
        }
        
        return nil
    }
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
        
        switch defaultResultType! {
        case .weight:
            _bestResultWeight = dict["best_result"] as? Float
        case .amrap:
            self.bestResultRounds = dict["best_result"] as? Int
        case .time:
            self.bestResultTime = dict["best_result"] as? Int
        default:
            break
        }
    }
    
    func add(personalRecord: PersonalRecord) {
        records.append(personalRecord)
    }
    
    private func timeAsString() -> String {
        guard let timeInSeconds = bestResultTime else {
            return "00:00"
        }
        
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds % 3600) / 60
        let seconds = (timeInSeconds % 3600) % 60
        
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func initBestRecord(with personalRecord: PersonalRecord) {
        switch defaultResultType! {
        case .weight:
            if _bestResultWeight == nil {
                _bestResultWeight = personalRecord._resultWeight
            } else if _bestResultWeight! < personalRecord._resultWeight! {
                _bestResultWeight = personalRecord._resultWeight
            }
        case .amrap:
            if bestResultRounds == nil {
                self.bestResultRounds = personalRecord.resultRounds
            } else if bestResultRounds! < personalRecord.resultRounds! {
                self.bestResultRounds = personalRecord.resultRounds
            }
        case .time:
            if bestResultTime == nil {
                self.bestResultTime = personalRecord.resultTime
            } else if bestResultTime! > personalRecord.resultTime! {
                self.bestResultTime = personalRecord.resultTime
            }
        default:
            break
        }
    }
    
    func updateBestRecord() {
        _bestResultWeight = nil
        bestResultTime = nil
        bestResultRounds = nil
        
        for record in records {
            initBestRecord(with: record)
        }
    }
}
