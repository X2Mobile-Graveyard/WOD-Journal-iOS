//
//  UIViewController+LoginPresenter.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentLoginScreen(with completion: (() -> Void)?) {
        showAlert(with: "Authenticate", message: "You need to log in to continue.", actionButtonTitle: "Login") { (alert) in
            self.showLogin(with: completion)
        }
    }
    
    func showLogin(with completion: (() -> Void)?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "authenticationScreensId") as? UINavigationController else {
            return
        }
        let loginController = navController.topViewController as! LoginViewController
        loginController.service = AuthenticationService(remote: AuthenticationRemoteServiceImpl())
        loginController.completion = completion
        
        modalTransitionStyle = .crossDissolve
        present(navController, animated: true, completion: nil)
    }
}
