//
//  RegisterViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD
import RSKImageCropper

class RegisterViewController: WODJournalResultViewController {
    
    // @IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmationTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userImageView: UIImageView!
    
    
    // @Injected
    var service: AuthenticationService!
    var completion: (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        pickedImageCompletion = {
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: self.userImage!, cropMode: .circle)
            
            imageCropVC.delegate = self
            
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }
    
    // MARK: - Buttons Actions

    @IBAction func didTapRegisterButton(_ sender: Any) {
        let enteredEmail = emailTextField.text
        let enteredPassword = passwordTextField.text
        let confirmedPassword = passwordConfirmationTextField.text
        let enteredName = userNameTextField.text
        
        MBProgressHUD.showAdded(to: view, animated: true)
        service.register(with: enteredEmail,
                         password: enteredPassword,
                         confirmationPassword: confirmedPassword,
                         name: enteredName,
                         imageUrl: pickedImagePath) { (result) in
            switch result {
            case let .success(userId):
                UserManager.sharedInstance.userId = userId
                UserManager.sharedInstance.userName = enteredName
                UserManager.sharedInstance.email = enteredEmail
                self.login(with: enteredEmail!, password: enteredPassword!)
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.handleError(result: result)
            }
        }
    }
    
    @IBAction func didTapUserImage(_ sender: Any) {
        if pickedImagePath == nil {
            presentAlertControllerForTakingPicture()
            return
        }
        
        presentAlertControllerForEditingPicture()
    }
    
    // MARK: - Login Methods
    
    private func login(with email: String, password: String) {
        service.login(with: email, password: password) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success():
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
    
    // MARK: - Image Handler
    
    
    override func removeUserImage() {
        pickedImagePath = nil
        userImageView.image = #imageLiteral(resourceName: "ios_blue_camera")
    }
    
    override func setUserImage() {
        guard let image = userImage else {
            return
        }
        
        userImageView.image = image
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
    }
}

extension RegisterViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        pickedImagePath = nil
        userImage = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                 usingCropRect cropRect: CGRect) {
        let imageName = "example"
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName)
        
        let data = UIImagePNGRepresentation(croppedImage)
        try? data?.write(to: URL(fileURLWithPath: localPath))
        
        pickedImagePath = localPath
        
        userImage = croppedImage
        
        setUserImage()
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
