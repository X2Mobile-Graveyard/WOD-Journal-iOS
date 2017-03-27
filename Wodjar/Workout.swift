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
}

enum WODCategory: String {
    case time = "Time"
    case amrap = "Repetitions"
    case weight = "Weight"
    case other = "Other"
}

enum UnitType {
    case imperial
    case metric
}

class Workout: NSObject {
    
    var id: Int
    var wodDescription: String?
    var imageUrl: String?
    var history: String?
    var type: WODType
    var name: String
    var isFavorite: Bool
    var isCompleted: Bool
    var category: WODCategory?
    var videoId: String?
    var unit: UnitType?
    var results: [WODResult]?
    
    init(id: Int, type: WODType, name: String, favorite: Bool, completed: Bool)   {
        self.id = id
        self.type = type
        self.name = name
        self.isFavorite = favorite
        self.isCompleted = completed
    }
    
    func set(description: String, image: String?, history: String?, category: WODCategory, video: String?, unit: UnitType) {
        self.wodDescription = description
        self.imageUrl = image
        self.history = history
        self.category = category
        self.videoId = video
        self.unit = unit
    }
}
