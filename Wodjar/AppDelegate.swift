//
//  AppDelegate.swift
//  Wodjar
//
//  Created by Bogdan on 01/03/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AWSCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let tabBarController = window?.rootViewController as! UITabBarController
        tabBarController.delegate = self
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let listController = navigationController.topViewController as! PersonalRecordsListViewController
        let service = PersonalRecordListService(remoteService: PersonalRecordListRemoteImpl())
        listController.service = service
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.EUWest2,
                                                                identityPoolId:"eu-west-2:a6b0223a-0d4f-41c2-903f-daf2b9097fb0")
        
        let configuration = AWSServiceConfiguration(region:.EUWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
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
                let girl1 = Workout(id: 1, type: .girl, name: "Ana", favorite: true, completed: true)
                let girl2 = Workout(id: 2, type: .girl, name: "Lucretia", favorite: false, completed: false)
                let girl3 = Workout(id: 3, type: .girl, name: "Jessica", favorite: false, completed: false)
                let girl4 = Workout(id: 4, type: .girl, name: "Sara", favorite: true, completed: true)
                
                let hero1 = Workout(id: 5, type: .hero, name: "Murf", favorite: true, completed: false)
                let hero2 = Workout(id: 6, type: .hero, name: "Joe", favorite: false, completed: true)
                let hero3 = Workout(id: 7, type: .hero, name: "Boy", favorite: false, completed: false)
                let hero4 = Workout(id: 8, type: .hero, name: "Cata", favorite: false, completed: true)
                
                let challenge1 = Workout(id: 9, type: .challenge, name: "Mineriada", favorite: false, completed: false)
                let challenge2 = Workout(id: 10, type: .challenge, name: "Revolutia", favorite: false, completed: false)
                let challenge3 = Workout(id: 11, type: .challenge, name: "Razboi", favorite: true, completed: true)
                let challenge4 = Workout(id: 12, type: .challenge, name: "Butoi", favorite: false, completed: true)
                
                let open1 = Workout(id: 13, type: .open, name: "17.1", favorite: false, completed: false)
                let open2 = Workout(id: 14, type: .open, name: "17.2", favorite: true, completed: false)
                let open3 = Workout(id: 15, type: .open, name: "17.3", favorite: false, completed: false)
                
                let cutom1 = Workout(id: 16, type: .custom, name: "Minge", favorite: false, completed: true)
                let custom2 = Workout(id: 17, type: .custom, name: "Ninge", favorite: true, completed: true)
                
                let workoutList = WorkoutList(workouts: [girl1, girl2, girl3, girl4, hero1, hero2, hero3, hero4, challenge1, challenge2, challenge3, challenge4, open1, open2, open3, custom2, cutom1])
                
                wodsController.workouts = workoutList

            }
        }
    }
}

