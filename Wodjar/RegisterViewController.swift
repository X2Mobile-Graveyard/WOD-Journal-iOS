//
//  RegisterViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // @Injected
    var service: AuthenticationService!
    var completion: (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didReleaseShowPasswordButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func didTapShowPasswordButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = false
    }

    @IBAction func didTapRegisterButton(_ sender: Any) {
        let enteredEmail = emailTextField.text
        let enteredPassword = passwordTextField.text
        
        MBProgressHUD.showAdded(to: view, animated: true)
        service.register(with: enteredEmail, password: enteredPassword) { (result) in
            switch result {
            case let .success(userId):
                UserManager.sharedInstance.userId = userId
                self.login(with: enteredEmail!, password: enteredPassword!)
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.handleError(result: result)
            }
        }
    }
    
    // MARK: - Login Methods
    
    private func login(with email: String, password: String) {
        service.login(with: email, password: password) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(_, accessToken):
                UserManager.sharedInstance.userToken = accessToken
                self.loginSuccedded()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func loginSuccedded() {
        dismiss(animated: true, completion: completion)
    }
}
