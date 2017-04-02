//
//  LoginViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // @Injected
    var service: AuthenticationService!
    var completion: (()->Void)?
    
    // @Constants
    let registerSegueIdentifier = "RegisterViewControllerSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTouchViewPasswordButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = false;
    }
    
    @IBAction func didReleaseViewPasswordButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = true;
    }

    @IBAction func didTapLoginWithFacebookButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.facebookLogin(on: self) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success((id, accessToken)):
                self.successLogin(with: id, accessToken: accessToken)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.login(with: emailTextField.text, password: passwordTextField.text) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success((id, accessToken)):
                self.successLogin(with: id, accessToken: accessToken)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func successLogin(with userId: Int, accessToken: String) {
        UserManager.sharedInstance.userId = userId
        UserManager.sharedInstance.userToken = accessToken
        
        self.dismiss(animated: true, completion: completion)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == registerSegueIdentifier {
            let registerVC = segue.destination as! RegisterViewController
            registerVC.service = service
            registerVC.completion = completion
        }
    }
}
