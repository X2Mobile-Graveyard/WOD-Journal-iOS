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

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

