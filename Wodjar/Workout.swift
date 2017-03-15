//
//  Workout.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

enum WODType {
    case girl
    case hero
    case challenge
    case open
    case custom
}

class Workout: NSObject {

    var type: WODType
    var name: String
    var isFavvorite: Bool
    
    init(type: WODType, name: String, favorite: Bool)   {
        self.type = type
        self.name = name
        self.isFavvorite = favorite
    }
}
