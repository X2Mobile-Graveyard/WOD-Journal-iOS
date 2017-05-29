//
//  MoreUserProfileTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/18/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreUserProfileTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    
    var delegate: UpdateUserDelegate!
    func populateCell() {
        userNameTextField.delegate = self
        userNameTextField.inputAccessoryView = createKeyboardToolbar(cancelButton: "Cancel",
                                                                     with: #selector(didTapCancel),
                                                                     doneButton: "Done",
                                                                     doneSelector: #selector(didTapDone))
        if UserManager.sharedInstance.userName == nil {
            userNameTextField.text = "Your name here"
        } else {
            userNameTextField.text = UserManager.sharedInstance.userName!
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        
        if UserManager.sharedInstance.imageUrl == nil {
            userImageView.image = #imageLiteral(resourceName: "add-user")
        } else {
            userImageView.sd_setImage(with: URL(string: UserManager.sharedInstance.imageUrl!),
                                      placeholderImage: #imageLiteral(resourceName: "placeholder_image_rounded"))
        }
    }
    
    func didTapCancel() {
        userNameTextField.text = UserManager.sharedInstance.userName!
        userNameTextField.resignFirstResponder()
    }
    
    func didTapDone() {
        if userNameTextField.text?.characters.count == 0 {
            userNameTextField.text = UserManager.sharedInstance.userName!
            userNameTextField.resignFirstResponder()
            return
        }
        
        userNameTextField.resignFirstResponder()
        delegate.updateUser(with: userNameTextField.text)
    }
    
    private func createKeyboardToolbar(with hiddingOtion: String, selector: Selector?) -> UIToolbar {
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardItem = UIBarButtonItem(title: hiddingOtion,
                                               style: .plain,
                                               target: self,
                                               action: selector)
        toolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    private func createKeyboardToolbar(cancelButton: String, with cancelSelector: Selector, doneButton:String?, doneSelector: Selector?) -> UIToolbar {
        let toolbar = createKeyboardToolbar(with: cancelButton, selector: cancelSelector)
        
        if doneButton == nil && doneSelector == nil {
            return toolbar
        }
        
        var doneTitle: String = "Done"
        if doneButton != nil {
            doneTitle = doneButton!
        }
        
        let doneKeyboardItem = UIBarButtonItem(title: doneTitle,
                                               style: .done,
                                               target: self,
                                               action: doneSelector)
        toolbar.items?.append(doneKeyboardItem)
        toolbar.sizeToFit()
        
        return toolbar
    }

}

extension MoreUserProfileTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.updateUser(with: textField.text)
        return true
    }
}
