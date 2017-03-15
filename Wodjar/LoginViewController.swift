//
//  LoginViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }

}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(result)
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logout")
    }
}
