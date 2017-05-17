//
//  WODResult.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODResult: NSObject {
    // @Constants
    let noImageString = ""

    var notes: String?
    var id: Int?
    var resultType: WODCategory = .weight
    var resultTime: Int?
    var resultWeight: Float?
    var resultRounds: Int?
    var rx: Bool = false
    var photoUrl: String?
    var date: Date = Date()
    var updatedAt: Date = Date()
    var unitType: UnitType {
        return UserManager.sharedInstance.unitType
    }
    
    convenience init(from dictionary: [String: Any], with type: WODCategory?) {
        self.init()
        self.id = dictionary["id"] as? Int ?? nil
        self.notes = dictionary["notes"] as? String ?? nil
        self.rx = dictionary["rx"] as? Bool ?? false
        self.photoUrl = dictionary["image_url"] as? String ?? nil
        if photoUrl == noImageString {
            self.photoUrl = nil
        }
        if let dateAsString = dictionary["date"] as? String  {
            self.date = dateAsString.getDateFromWodJournalFormatStyle()
        }
        if let updatedAtString = dictionary["updated_at"] as? String {
            self.date = updatedAtString.getDateFromWodJournalFormatStyle()
        }
        if let resultTypeInt = dictionary["result_type"] as? Int {
            self.resultType = WODCategory.from(hashValue: resultTypeInt)
        }
        if type != nil {
            self.resultType = type!
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
    
    convenience init(with id: Int,
                     notes: String?,
                     resultType: WODCategory,
                     time: Int?,
                     weight: Float?,
                     rounds: Int?,
                     rx: Bool,
                     photoUrl: String?,
                     date: String,
                     updated_at: String) {
        self.init()
        self.id = id
        self.notes = notes
        self.resultType = resultType
        self.resultTime = time
        self.resultRounds = rounds
        self.resultWeight = weight
        self.rx = rx
        self.photoUrl = photoUrl
        self.date = date.getDateFromWodJournalFormatStyle()
        self.updatedAt = updated_at.getDateFromWodJournalFormatStyle()
    }
    
    convenience init(wodResult: WODResult) {
        self.init()
        self.id = wodResult.id
        self.rx = wodResult.rx
        self.resultTime = wodResult.resultTime
        self.resultRounds = wodResult.resultRounds
        self.resultWeight = wodResult.resultWeight
        self.resultType = wodResult.resultType
        self.date = wodResult.date
        self.notes = wodResult.notes
        self.date = wodResult.date
        self.photoUrl = wodResult.photoUrl
    }
    
    func updateValues(from wodResult: WODResult) {
        self.id = wodResult.id
        self.rx = wodResult.rx
        self.resultTime = wodResult.resultTime
        self.resultRounds = wodResult.resultRounds
        self.resultWeight = wodResult.resultWeight
        self.resultType = wodResult.resultType
        self.date = wodResult.date
        self.notes = wodResult.notes
        self.date = wodResult.date
        self.photoUrl = wodResult.photoUrl
    }
    
    func resultAsString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
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
                return timeAsString()
            }
            return nil
        default:
            break
        }
        
        return nil
    }
    
    func updateResult(from result: String?) {
        guard let result = result else {
            return
        }
        
        let numberFormatter = NumberFormatter()
        switch resultType {
        case .weight:
            resultWeight = numberFormatter.number(from: result)?.floatValue
        case .amrap:
            resultRounds = numberFormatter.number(from: result)?.intValue
        case .time:
            resultTime = getSeconds(from: result)
        default:
            break
        }
    }

    
    private func timeAsString() -> String {
        guard let timeInSeconds = resultTime else {
            return "0:0"
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
    
    func createUpdateDict(with wodId: Int, wodType: WODType) -> [String: Any] {
        var updateDict = [String: Any]()
        
        if id != nil {
            updateDict["id"] = id!
        }
        
        if notes != nil {
            updateDict["notes"] = notes!
        }
        
        switch resultType {
        case .weight:
            if unitType == .imperial {
                updateDict["result_weight"] = resultWeight!.convertToMetric()
            } else {
                updateDict["result_weight"] = resultWeight!
            }
        case .amrap:
            updateDict["result_rounds"] = resultRounds!
        case .time:
            updateDict["result_time"] = resultTime!
        default:
            break
        }
        
        updateDict["rx"] = rx
        if let url = photoUrl {
            updateDict["image_url"] = url
        } else {
            updateDict["image_url"] = noImageString
        }
        
        updateDict["date"] = date.getWodJournalFormatString()
        updateDict["wod_id"] = wodId
        updateDict["default"] = wodType != .custom
        
        return updateDict
    }
}
