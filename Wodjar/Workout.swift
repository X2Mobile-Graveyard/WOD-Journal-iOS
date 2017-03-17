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

class Workout: NSObject {

    var type: WODType
    var name: String
    var isFavorite: Bool
    var isCompleted: Bool
    
    init(type: WODType, name: String, favorite: Bool, completed: Bool)   {
        self.type = type
        self.name = name
        self.isFavorite = favorite
        self.isCompleted = completed
    }
}
