//
//  WorkoutList.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WorkoutList: NSObject {

    var workouts: [Workout] = []
    var girls: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.type == .girl
        }
    }
    var heroes: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.type == .hero
        }
    }
    var chalanges: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.type == .challenge
        }
    }
    var opens: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.type == .open
        }
    }
    var customs: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.type == .custom
        }
    }
    var favorites: [Workout] {
        return self.workouts.filter { (workout) -> Bool in
            return workout.isFavvorite
        }
    }
    
    convenience init(workouts: [Workout]) {
        self.init()
        self.workouts = workouts
    }
    
    func numberOfSections() -> Int {
        var sections = 0
        if girls.count > 0 {
           sections += 1
        }
        
        if heroes.count > 0 {
            sections += 1
        }
        
        if chalanges.count > 0 {
            sections += 1
        }
        
        if opens.count > 0 {
            sections += 1
        }
        
        if customs.count > 0 {
            sections += 1
        }
        
        return sections
    }
}
