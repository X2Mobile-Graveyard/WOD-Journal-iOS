//
//  MoreViewController.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    public static let premiumSubscription = "com.x2mobile.Wodjar.premiumanualsub"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [premiumSubscription]
    
    public static let store = IAPHelper(productIds: productIdentifiers)
    
    // MARK: - IBActions
    
    @IBAction func didTapUnitsComponent(_ sender: Any) {
        let index = (sender as! UnitsComponent).index
        
        print(index)
    }
    
    @IBAction func didTapMoreComponent(_ sender: UIView) {
        switch sender.tag {
        case 1:
            // send feedback email
            sendMail()
        case 2:
            // purchase premium subscription
            MoreViewController.store.requestProducts(completionHandler: { success, products  in
                if success {
                    print("success")
                }
            })
        case 3:
            // restore premium subscription
            print("restore purchases")
            MoreViewController.store.restorePurchases()
            
        default:
            break
        }
    }
}
