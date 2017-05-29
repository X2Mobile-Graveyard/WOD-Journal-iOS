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
import Fabric
import Crashlytics
import AVFoundation
import SwiftyStoreKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        completeTransaction()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        tabBarController.delegate = self
        let navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let listController = navigationController.topViewController as! PersonalRecordsListViewController
        let service = PersonalRecordListService(remoteService: PersonalRecordListRemoteImpl())
        listController.service = service
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        setupAmazonS3Capabilities()
        Fabric.with([Crashlytics.self])
        
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 14 / 255, green: 122 / 255, blue: 254 / 255, alpha: 1)
        
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
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
    
    private func setupAmazonS3Capabilities() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.EUWest2,
                                                                identityPoolId:"eu-west-2:a6b0223a-0d4f-41c2-903f-daf2b9097fb0")
        
        let configuration = AWSServiceConfiguration(region:.EUWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration

    }
    
    private func completeTransaction() {
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    if product.needsFinishTransaction {
                        if product.productId == MoreViewController.premiumMonthlySubscription {
                            UserManager.sharedInstance.hasMonthlySubscription = true
                        }
                        
                        if product.productId == MoreViewController.premiumAnualSubscription {
                            UserManager.sharedInstance.hasYearSubscription = true
                        }
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                }
            }
        }
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController {
            if let wodsController = navController.topViewController as? WODTypesTableViewController {
                if wodsController.service == nil {
                    wodsController.service = WODListService(listRemote: WODListRemoteServiceImpl(), wodRemote: WODRemoteServiceImpl())
                }
                
                return
            }
            
            if let moreController = navController.topViewController as? MoreTableViewController {
                if moreController.service == nil {
                    moreController.service = UserService(s3RemoteService: S3RemoteService(), remoteService: UserRemoteServiceImpl())
                }
            }
        }
    }
}
