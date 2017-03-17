//
//  AppDelegate.swift
//  Wodjar
//
//  Created by Bogdan on 01/03/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let tabBarController = window?.rootViewController as! UITabBarController
        tabBarController.delegate = self
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let listController = navigationController.topViewController as! PersonalRecordsListViewController
        
        let personalRecord1 = PersonalRecord(name: "Deadlift",
                                             rx: true,
                                             result: "59",
                                             resultType: .weight,
                                             unitType: .metric,
                                             notes: "No notes ywe",
                                             imageUrl: nil,
                                             date: Date())
        let personalRecord2 = PersonalRecord(name: "Deadlift",
                                             rx: false,
                                             result: "32",
                                             resultType: .repetitions,
                                             unitType: .imperial,
                                             notes: nil,
                                             imageUrl: nil,
                                             date: Date())
        let personalRecord3 = PersonalRecord(name: "Running",
                                             rx: true,
                                             result: "34:23",
                                             resultType: .time,
                                             unitType: .metric,
                                             notes: "No notes ywe",
                                             imageUrl: nil,
                                             date: Date())
        let personalRecord4 = PersonalRecord(name: "Running",
                                             rx: false,
                                             result: "43:23",
                                             resultType: .time,
                                             unitType: .imperial,
                                             notes: nil,
                                             imageUrl: nil,
                                             date: Date())
        let personalRecord5 = PersonalRecord(name: "Pushups",
                                             rx: true,
                                             result: "20",
                                             resultType: .repetitions,
                                             unitType: .metric,
                                             notes: "No notes ywe",
                                             imageUrl: nil,
                                             date: Date())
        let personalRecord6 = PersonalRecord(name: "Pushups",
                                             rx: false,
                                             result: "32",
                                             resultType: .repetitions,
                                             unitType: .imperial,
                                             notes: nil,
                                             imageUrl: nil,
                                             date: Date())
       
        let personalRecordType1 = PersonalRecordType(name: "Deadlift", present: true)
        personalRecordType1.add(personalRecord: personalRecord1)
        personalRecordType1.add(personalRecord: personalRecord2)
        
        let personalRecordType2 = PersonalRecordType(name: "Running", present: false)
        personalRecordType2.add(personalRecord: personalRecord3)
        personalRecordType2.add(personalRecord: personalRecord4)
        
        let personalRecordType3 = PersonalRecordType(name: "Pushups", present: true)
        personalRecordType3.add(personalRecord: personalRecord5)
        personalRecordType3.add(personalRecord: personalRecord6)
        
        listController.recordTypes = [personalRecordType1, personalRecordType2, personalRecordType3];
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController {
            if let wodsController = navController.topViewController as? WODTypesTableViewController {
                let girl1 = Workout(type: .girl, name: "Ana", favorite: true, completed: true)
                let girl2 = Workout(type: .girl, name: "Lucretia", favorite: false, completed: false)
                let girl3 = Workout(type: .girl, name: "Jessica", favorite: false, completed: false)
                let girl4 = Workout(type: .girl, name: "Sara", favorite: true, completed: true)
                
                let hero1 = Workout(type: .hero, name: "Murf", favorite: true, completed: false)
                let hero2 = Workout(type: .hero, name: "Joe", favorite: false, completed: true)
                let hero3 = Workout(type: .hero, name: "Boy", favorite: false, completed: false)
                let hero4 = Workout(type: .hero, name: "Cata", favorite: false, completed: true)
                
                let challenge1 = Workout(type: .challenge, name: "Mineriada", favorite: false, completed: false)
                let challenge2 = Workout(type: .challenge, name: "Revolutia", favorite: false, completed: false)
                let challenge3 = Workout(type: .challenge, name: "Razboi", favorite: true, completed: true)
                let challenge4 = Workout(type: .challenge, name: "Butoi", favorite: false, completed: true)
                
                let open1 = Workout(type: .open, name: "17.1", favorite: false, completed: false)
                let open2 = Workout(type: .open, name: "17.2", favorite: true, completed: false)
                let open3 = Workout(type: .open, name: "17.3", favorite: false, completed: false)
                
                let cutom1 = Workout(type: .custom, name: "Minge", favorite: false, completed: true)
                let custom2 = Workout(type: .custom, name: "Ninge", favorite: true, completed: true)
                
                let workoutList = WorkoutList(workouts: [girl1, girl2, girl3, girl4, hero1, hero2, hero3, hero4, challenge1, challenge2, challenge3, challenge4, open1, open2, open3, custom2, cutom1])
                
                wodsController.workouts = workoutList
            }
        }
    }
}

