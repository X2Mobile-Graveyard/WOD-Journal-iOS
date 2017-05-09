//
//  ProSubscriptionViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class ProSubscriptionViewController: UIViewController {
    
    // @Injected
    var annualProduct: SKProduct!
    var mothlyProduct: SKProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapAnualButton(_ sender: Any) {
//        MoreViewController.store.buyProduct(annualProduct)
        SwiftyStoreKit.purchaseProduct(MoreViewController.premiumAnualSubscription, atomically: true) { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                UserManager.sharedInstance.hasYearSubscription = true
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                default:
                    break
                }
            }
        }
    }

    @IBAction func didTapOutsideView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapMonthButton(_ sender: Any) {
//        MoreViewController.store.buyProduct(mothlyProduct)
        SwiftyStoreKit.purchaseProduct(MoreViewController.premiumMonthlySubscription, atomically: true) { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                UserManager.sharedInstance.hasMonthlySubscription = true
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                default:
                    break
                }
            }
        }
    }
}
