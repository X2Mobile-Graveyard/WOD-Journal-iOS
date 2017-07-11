//
//  PersonalRecord.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/9/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class PersonalRecord {
    // @Constants
    let noImageString = ""
    
    // @Variables
    var id: Int?
    var name: String? = nil
    var rx: Bool = false
    var resultType: WODCategory = .weight
    public private(set) var _resultWeight: Float?
    var resultWeight: Float? {
        set {
            self._resultWeight = newValue
        }
        
        get {
            if self.unitType == .imperial {
               return self._resultWeight?.convertToImperial()
            }
            
            return self._resultWeight
        }
    }
    var resultTime: Int?
    var resultRounds: Int?
    var unitType: UnitType {
        return UserManager.sharedInstance.unitType
    }
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
        self.rx = dictionary["rx"] as? Bool ?? false
        if let resultTypeInt = dictionary["result_type"] as? Int {
            self.resultType = WODCategory.from(hashValue: resultTypeInt)
        }
        self.notes = dictionary["notes"] as? String ?? nil
        self.imageUrl = dictionary["image_url"] as? String ?? nil
        if self.imageUrl == noImageString {
            self.imageUrl = nil
        }
        if let lastUpdate = dictionary["updated_at"] as? String {
            self.updatedAt = lastUpdate.getDateFromWodJournalFormatStyle()
        } else {
            self.updatedAt = nil
        }
        
        if let userDate = dictionary["date"] as? String {
            self.date = userDate.getDateFromWodJournalFormatStyle()
        }
        
        switch resultType {
        case .weight:
            self.resultWeight = dictionary["result_weight"] as? Float ?? 0
        case .amrap:
            self.resultRounds = dictionary["result_rounds"] as? Int ?? 0
        case .time:
            self.resultTime = dictionary["result_time"] as? Int ?? 0
        default:
            break
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
        self.resultType = resultType
        self.notes = notes
        self.imageUrl = imageUrl
        self.date = date
        self.updateResult(from: result)
    }
    
    convenience init(personalRecord: PersonalRecord) {
        self.init()
        self.id = personalRecord.id
        self.name = personalRecord.name
        self.rx = personalRecord.rx
        self.resultTime = personalRecord.resultTime
        self.resultRounds = personalRecord.resultRounds
        self._resultWeight = personalRecord._resultWeight
        self.resultType = personalRecord.resultType
        self.date = personalRecord.date
        self.notes = personalRecord.notes
        self.imageUrl = personalRecord.imageUrl
        self.date = personalRecord.date
    }
    
    func updateValues(from personalRecord: PersonalRecord) {
        self.id = personalRecord.id
        self.name = personalRecord.name
        self.rx = personalRecord.rx
        self._resultWeight = personalRecord._resultWeight
        self.resultRounds = personalRecord.resultRounds
        self.resultTime = personalRecord.resultTime
        self.resultType = personalRecord.resultType
        self.date = personalRecord.date
        self.notes = personalRecord.notes
        self.imageUrl = personalRecord.imageUrl
        self.date = personalRecord.date
    }
    
    func createDict() -> [String: Any] {
        var updateDict = [String: Any]()
        
        updateDict["rx"] = self.rx
        updateDict["result_type"] = self.resultType.hash()
        if let notes = self.notes {
            updateDict["notes"] = notes
        }
        
        if let url = imageUrl {
            updateDict["image_url"] = url
        } else {
            updateDict["image_url"] = noImageString
        }
        
        updateDict["date"] = self.date.getWodJournalFormatString()
        
        switch resultType {
        case .weight:
            updateDict["result_weight"] = _resultWeight!
        case .amrap:
            updateDict["result_rounds"] = resultRounds!
        case .time:
            updateDict["result_time"] = resultTime!
        case .other:
            break
        }
        
        return updateDict
    }
    
    func updateDict() -> [String: Any] {
        var updateDict = [String: Any]()
        
        updateDict["name"] = self.name!
        updateDict["rx"] = self.rx
        updateDict["result_type"] = self.resultType.hash()
        if let notes = self.notes {
            updateDict["notes"] = notes
        }
        
        if let url = imageUrl {
            updateDict["image_url"] = url
        } else {
            updateDict["image_url"] = noImageString
        }
        
        updateDict["date"] = self.date.getWodJournalFormatString()
        
        switch resultType {
        case .weight:
            updateDict["result_weight"] = _resultWeight!
        case .amrap:
            updateDict["result_rounds"] = resultRounds!
        case .time:
            updateDict["result_time"] = resultTime!
        case .other:
            break
        }
        
        return updateDict
    }
    
    func updateResult(from result: String?) {
        guard let result = result else {
            return
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        switch resultType {
        case .weight:
            let weightInType = numberFormatter.number(from: result)?.floatValue
            if unitType == .imperial {
                resultWeight = weightInType?.convertToMetric()
            } else {
                resultWeight = weightInType
            }
        case .amrap:
            resultRounds = numberFormatter.number(from: result)?.intValue
        case .time:
            resultTime = getSeconds(from: result)
        default:
            break
        }
    }
    
    func resultAsString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 2
        switch resultType {
        case .weight:
            if resultWeight != nil {
                let resultNumber = NSNumber(value: resultWeight!)
                return "\(numberFormatter.string(from: resultNumber)!)"
            }
            return nil
        case .amrap:
            if resultRounds != nil {
                return "\(resultRounds!)"
            }
            return nil
        case .time:
            if resultTime != nil {
                let timeString = timeAsString()
                return timeString == "00:00" ? nil : timeString
            }
            return nil
        default:
            break
        }
        
        return nil
    }
    
    private func timeAsString() -> String {
        guard let timeInSeconds = resultTime else {
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
    
    private func getSeconds(from time: String) -> Int {
        let timeComponents = time.components(separatedBy: ":")
        
        if timeComponents.count < 2 {
            return 0;
        }
        
        if timeComponents.count == 2 {
            guard let seconds = Int(timeComponents[1]) else {
                return 0
            }
            guard let minutes = Int(timeComponents[0]) else {
                return seconds
            }
            
            return minutes * 60 + seconds
        }
        
        guard let seconds = Int(timeComponents[2]) else {
            return 0
        }
        
        guard let minutes = Int(timeComponents[1]) else {
            return seconds
        }
        
        guard let hours = Int(timeComponents[0]) else {
            return minutes * 60 + seconds
        }
        
        return hours * 3600 + minutes * 60 + seconds
    }
    
}

extension Float {
    func convertToImperial() -> Float {
        return self * 2.20462262185
    }
    
    func convertToMetric() -> Float {
        return self * 0.45359237
    }
}
