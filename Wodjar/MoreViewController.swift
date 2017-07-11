//
//  MoreViewController.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import StoreKit
import MBProgressHUD
import SwiftyStoreKit


class MoreViewController: UIViewController {
    
    // @Constants
    
    let detailsSegueIdentifier = "PremiumSubscriptionDescriptionIdentifier"
    
    // @IBOutlets
    
    @IBOutlet var authenticationButton: UIButton!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var unitSystemComponent: UnitsComponent!

    public static let premiumAnualSubscription = "com.x2mobile.Wodjar.PremiumAnualSubs"
    public static let premiumMonthlySubscription = "com.x2mobile.Wodjar.premiummonthlysubs"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [premiumAnualSubscription, premiumMonthlySubscription]
    
    public static let store = IAPHelper(productIds: productIdentifiers)
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    
    // MARK: - UI Initialization
    
    func initUI() {
        if UserManager.sharedInstance.isAuthenticated() {
            authenticationButton.setTitle("Logout", for: .normal)
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        
        versionLabel.text = "v\(version)(\(build))"
        
        unitSystemComponent.index = UserManager.sharedInstance.unitType.rawValue
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapUnitsComponent(_ sender: Any) {
        let index = (sender as! UnitsComponent).index
        
        if UserManager.sharedInstance.isAuthenticated() {
            UserManager.sharedInstance.unitType = UnitType(rawValue: index)!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UnitType"), object: nil)
        }
    }
    
    @IBAction func didTapMoreComponent(_ sender: UIView) {
        switch sender.tag {
        case 1:
            // send feedback email
//            sendMail()
            break
        case 2:
            MBProgressHUD.showAdded(to: view, animated: true)
            MoreViewController.store.requestProducts(completionHandler: { (success, products) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if success {
                    self.products = products!
                    if self.products.count == 2
                    {
                        self.performSegue(withIdentifier: self.detailsSegueIdentifier, sender: self)
                    }
                }
            })
        case 3:
            // restore premium subscription
            print("restore purchases")
            SwiftyStoreKit.restorePurchases(atomically: false) { results in
                if results.restoreFailedPurchases.count > 0 {
                    print("Restore Failed: \(results.restoreFailedPurchases)")
                }
                else if results.restoredPurchases.count > 0 {
                    for product in results.restoredPurchases {
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                    }
                    print("Restore Success: \(results.restoredPurchases)")
                }
                else {
                    print("Nothing to Restore")
                }
            }
            
        default:
            break
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        if UserManager.sharedInstance.isAuthenticated() {
            signOut()
            return
        }
        
        showLogin {
            self.authenticationButton.setTitle("Logout", for: .normal)
            self.resetViewControllers()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == detailsSegueIdentifier {
            let subsViewController = segue.destination as! ProSubscriptionViewController
            for product in products {
                if product.productIdentifier == MoreViewController.premiumAnualSubscription {
                    subsViewController.annualProduct = product
                }
                
                if product.productIdentifier == MoreViewController.premiumMonthlySubscription {
                    subsViewController.mothlyProduct = product
                }
            }
        }
    }
    
    // MARK: - Service Calls
    
    func signOut() {
        UserManager.sharedInstance.signOut()
        self.authenticationButton.setTitle("Login", for: .normal)
        self.resetViewControllers()
    }
}
