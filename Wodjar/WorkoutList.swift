//
//  WorkoutList.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WorkoutList: NSObject {

    var wodTypesOrder: [WODType] = [.girl, .hero, .challenge, .open]
    var workouts: [Workout] = []
    var girls: [Workout] {
        return self.workouts.filter {
            return $0.type == .girl
        }
    }
    var heroes: [Workout] {
        return self.workouts.filter {
            return $0.type == .hero
        }
    }
    var chalanges: [Workout] {
        return self.workouts.filter {
            return $0.type == .challenge
        }
    }
    var opens: [Workout] {
        return self.workouts.filter {
            return $0.type == .open
        }
    }
    var customs: [Workout] {
        return self.workouts.filter {
            return $0.type == .custom
        }
    }
    var favorites: [Workout] {
        return self.workouts.filter {
            return $0.isFavorite
        }
    }
    
    convenience init(workouts: [Workout]) {
        self.init()
        self.workouts = workouts
    }
    
    func filteredSections() -> [WODType] {
        var sectionsNames = [WODType]()
        
        if girls.count > 0 {
            sectionsNames.append(.girl)
        }
        
        if heroes.count > 0 {
            sectionsNames.append(.hero)
        }
        
        if chalanges.count > 0 {
            sectionsNames.append(.challenge)
        }
        
        if opens.count > 0 {
            sectionsNames.append(.open)
        }
        
        if customs.count > 0 {
            sectionsNames.append(.custom)
        }
        
        return sectionsNames
    }
    
    func getWorkouts(for wodType: WODType) -> [Workout] {
        switch wodType {
        case .challenge:
            return chalanges
        case .custom:
            return customs
        case .girl:
            return girls
        case .hero:
            return heroes
        case .open:
            return opens
        }
    }
    
    func workout(with type: WODType, at index: Int) -> Workout {
        switch type {
        case .girl:
            return girls[index]
        case .hero:
            return heroes[index]
        case .challenge:
            return chalanges[index]
        case .custom:
            return customs[index]
        case .open:
            return opens[index]
        }
    }
    
    func totalWods(for wodType: WODType) -> Int {
        switch wodType {
        case .girl:
            return girls.count
        case .hero:
            return heroes.count
        case .challenge:
            return chalanges.count
        case .open:
            return opens.count
        case .custom:
            return customs.count
         
        }
    }
    
    func completedWods(for wodType: WODType) -> Int {
        var completed = [Workout]()
        switch wodType {
        case .girl:
            completed = self.girls.filter {
                return $0.isCompleted
            }
        case .hero:
            completed = self.heroes.filter {
                return $0.isCompleted
            }
        case .challenge:
            completed = self.chalanges.filter {
                return $0.isCompleted
            }
        case .open:
            completed = self.opens.filter {
                return $0.isCompleted
            }
        case .custom:
            completed = self.customs.filter {
                return $0.isCompleted
            }
            
        }
        
        return completed.count
    }
    
}
