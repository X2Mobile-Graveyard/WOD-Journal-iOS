//
//  MoreViewController.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet var authenticationButton: UIButton!
    

    public static let premiumSubscription = "com.x2mobile.Wodjar.premiumanualsub"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [premiumSubscription]
    
    public static let store = IAPHelper(productIds: productIdentifiers)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.sharedInstance.isAuthenticated() {
            authenticationButton.setTitle("Logout", for: .normal)
        }
    }
    
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
                    UserManager.sharedInstance.hasPremiumSubscription = true
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
    
    @IBAction func didTapLogin(_ sender: Any) {
        if UserManager.sharedInstance.isAuthenticated() {
            UserManager.sharedInstance.signOut()
            authenticationButton.setTitle("Login", for: .normal)
            return
        }
        
        showLogin {
            self.authenticationButton.setTitle("Logout", for: .normal)
        }
    }
    
}
