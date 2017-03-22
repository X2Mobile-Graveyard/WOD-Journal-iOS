//
//  UIViewController+ErrorHandler.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Error Handler
    
    func handle(_ error: Error) {
        // present the localized error message
        present(error)
        
        // TODO - add error handling here maybe?
    }
    
    // MARK: - Present Error Message
    
    func present(_ error: Error) {
        DispatchQueue.main.async {
            let title = "Error"
            let message = error.localizedDescription
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(action)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
    
