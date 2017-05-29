//
//  main.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/27/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SwiftyStoreKit

//let appleValidator = AppleReceiptValidator(service: .production)
//SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "3aaa7a730647487b8b1ef0f0311c3fcc") { result in
//    switch result {
//    case .success(let receipt):
//        let monthPurchaseResult = SwiftyStoreKit.verifyPurchase(
//            productId: MoreViewController.premiumMonthlySubscription,
//            inReceipt: receipt)
//        
//        let yearPurchaseResult = SwiftyStoreKit.verifyPurchase(
//            productId: MoreViewController.premiumAnualSubscription,
//            inReceipt: receipt)
//        
//        switch monthPurchaseResult {
//        case .purchased(let expiresDate):
//            UserManager.sharedInstance.hasMonthlySubscription = true
//        case .notPurchased:
//            UserManager.sharedInstance.hasMonthlySubscription = false
//        }
//        
//        switch yearPurchaseResult {
//        case .purchased(let expiresDate):
//            UserManager.sharedInstance.hasYearSubscription = true
//        case .notPurchased:
//            UserManager.sharedInstance.hasYearSubscription = false
//        }
//        
//    case .error(let error):
//        print("Receipt verification failed: \(error)")
//    }
//}

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(AppDelegate.self)
)





