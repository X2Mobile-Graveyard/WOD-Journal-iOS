//
//  Workout.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

enum WODType: String {
    case girl = "Girls"
    case hero = "Heroes"
    case challenge = "Challenges"
    case open = "Opens"
    case custom = "Customs"
    
    static func from(hashValue: Int) -> WODType {
        switch hashValue {
        case 0:
            return .girl
        case 1:
            return .hero
        case 2:
            return .challenge
        case 3:
            return .open
        case 4:
            return .custom
        default:
            return .custom
        }
    }
    
    func hash() -> Int {
        switch self {
        case .girl:
            return 0
        case .hero:
            return 1
        case .challenge:
            return 2
        case .open:
            return 3
        case .custom:
            return 4
        }
    }
}

enum WODCategory: String {
    case time = "Time"
    case amrap = "Rounds/Reps"
    case weight = "Weight"
    case other = "Other"
    
    static func from(hashValue: Int) -> WODCategory {
        switch hashValue {
        case 0:
            return .weight
        case 1:
            return .amrap
        case 2:
            return .time
        default:
            return .other
        }
    }
    
    func hash() -> Int {
        switch self {
        case .weight:
            return 0
        case .amrap:
            return 1
        case .time:
            return 2
        case .other:
            return 3
        }
    }
}

enum UnitType: Int {
    case imperial
    case metric
}

class Workout: NSObject {
    // @Constants
    let noImageString = ""
    
    var id: Int?
    var wodDescription: String?
    var imageUrl: String?
    var history: String?
    var type: WODType?
    var name: String?
    var isFavorite: Bool = false
    var isCompleted: Bool = false
    var isDefault: Bool = true
    var category: WODCategory?
    var videoId: String?
    var unit: UnitType?
    var results: [WODResult]?
    var lastResults: [WODResult]? {
        if results == nil {
            return nil
        }
        
        if UserManager.sharedInstance.hasPremiumSubscription {
            return results
        }
        
        if results!.count <= 3 {
            return results
        }
        
        return Array((results!.prefix(3)))
    }
    
    convenience init(id: Int, type: WODType, name: String, favorite: Bool, completed: Bool)   {
        self.init()
        self.id = id
        self.type = type
        self.name = name
        self.isFavorite = favorite
        self.isCompleted = completed
    }
    
    convenience init(from dictionary: [String: Any]) {
        self.init()
        self.id = dictionary["id"] as? Int ?? nil
        self.name = dictionary["name"] as? String ?? nil
        if let type = dictionary["wod_type"] as? Int {
            self.type = WODType.from(hashValue: type)
        }
        self.wodDescription = dictionary["description"] as? String ?? nil
        self.imageUrl = dictionary["image"] as? String ?? nil
        if imageUrl == noImageString {
            self.imageUrl = nil
        }
        self.history = dictionary["history"] as? String ?? nil
        if let category = dictionary["category"] as? Int {
            self.category = WODCategory.from(hashValue: category)
        } else {
            print("ASdasd")
        }
        self.videoId = dictionary["video"] as? String ?? nil
        self.isCompleted = dictionary["completed"] as? Bool ?? false
        self.isFavorite = dictionary["favorites"] as? Bool ?? false
        self.isDefault = dictionary["default"] as? Bool ?? true
    }
    
    convenience init(using wod: Workout) {
        self.init()
        self.id = wod.id
        self.wodDescription = wod.wodDescription
        self.imageUrl = wod.imageUrl
        self.history = wod.history
        self.type = wod.type
        self.name = wod.name
        self.isFavorite = wod.isFavorite
        self.isCompleted = wod.isCompleted
        self.category = wod.category
        self.videoId = wod.videoId
        self.unit = wod.unit
        self.results = wod.results
        self.isDefault = wod.isDefault
    }
    
    func updateValues(from wod: Workout) {
        self.id = wod.id
        self.wodDescription = wod.wodDescription
        self.imageUrl = wod.imageUrl
        self.history = wod.history
        self.type = wod.type
        self.name = wod.name
        self.isFavorite = wod.isFavorite
        self.isCompleted = wod.isCompleted
        self.category = wod.category
        self.videoId = wod.videoId
        self.unit = wod.unit
        self.results = wod.results
        self.isDefault = wod.isDefault
    }
    
    func set(description: String, image: String?, history: String?, category: WODCategory, video: String?, unit: UnitType) {
        self.wodDescription = description
        self.imageUrl = image
        self.history = history
        self.category = category
        self.videoId = video
        self.unit = unit
    }
    
    func createUpdateDict() -> [String: Any] {
        var updateDict = [String: Any]()
        
        updateDict["name"] = self.name!
        updateDict["wod_type"] = self.type?.hash()
        updateDict["description"] = self.wodDescription
        if let url = imageUrl {
            updateDict["image"] = url
        } else {
            updateDict["image"] = noImageString
        }
        updateDict["category"] = self.category?.hash()
        return updateDict
    }
    
    func orderResults() {
        if results == nil {
            return
        }
        if results!.count < 2 {
            return
        }
        
        results!.sort { (result1, result2) -> Bool in
            if result1.updatedAt.compare(result2.updatedAt) == .orderedAscending {
                return false
            }
            return true
        }
    }
}
