//
//  UIViewController+AlertController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, message: String, actionButtonTitle: String, actionHandler:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let otherAction = UIAlertAction(title: actionButtonTitle, style: .default, handler: actionHandler)
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
