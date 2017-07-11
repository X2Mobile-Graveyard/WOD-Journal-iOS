//
//  UIViewController+Result.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result
import AFNetworking

extension UIViewController {
    
    func resetViewControllers() {
        for viewController in (tabBarController?.viewControllers)! {
            if let navController = viewController as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Auth"), object: nil)
    }
    
    func handleError<T>(result: Result<T, NSError>) {
        switch result {
        case .success(_): break
        case let .failure(error):
            if error.domain == "local.domain" {
                showError(with: error.userInfo["error"] as! String)
                return
            }
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                showError(with: error.localizedDescription)
                return
            }
            
            if (error.code == -1011) {
                if let respose = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse {
                    let statusCode = respose.statusCode
                    let url = respose.url!.absoluteString
                    if statusCode == 401 && !url.contains("sign-in") && !url.contains("users") {
                        UserManager.sharedInstance.signOut()
                        showAlert(with: "Warning",
                                  message: "You have been logged out. Please login.",
                                  actionButtonTitle: "Login",
                                  actionHandler: { (alert) in
                                    self.showLogin(with: {
                                        self.resetViewControllers()
                                    })
                        },
                                  cancelButtonTitle: "Cancel",
                                  cancelHandler: { (alert) in
                                    self.resetViewControllers()
                        })
                        return
                    }
                }
                let errorMessage = handleInternalServer(error: error)
                showError(with: errorMessage)
            } else {
                showError(with: error.description)
            }
        }
    }
    
    func handleResultOrDisplayError<T>(result: Result<T, NSError>, successHandler: ((T) -> ())?) {
        switch result {
        case let .success(value):
            successHandler?(value)
        case .failure(_):
            handleError(result: result)
        }
    }
    
    func getErrorMessage(error: NSError) -> String {
        if error.domain == "local.domain" {
            return error.userInfo["errors"] as! String
        }
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
            return error.localizedDescription
        }
        
        if (error.code == -1011) {
            return handleInternalServer(error: error)
        } else {
            return error.localizedDescription
        }
    }
    
    private func handleInternalServer(error: NSError) -> String {
        if let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = json as? [String: Any] {
                return handle(error: error, inDictionary: dictionary)
            }
            
            if let array = json as? [Any] {
                return handle(error: error, inArray: array)
            }
            
            return error.localizedDescription
        }
        
        return error.localizedDescription
    }
    
    private func handle(error: NSError, inDictionary dictionary: [String:Any]) -> String {
        if let messages = dictionary["errors"] as? [Any] {
            let message = getErrorMessageFrom(messagesArray: messages)
            return message
        } else if let message = dictionary["detail"] as? String {
            return message
        } else {
            return error.localizedDescription
        }
    }
    
    private func handle(error: NSError, inArray array: [Any]) -> String {
        if array.count > 0 {
            if let singleMsg = array[0] as? String {
                return singleMsg
            }
            
            let message = getErrorMessageFrom(messagesArray: array)
            return message
            
        } else {
            return error.localizedDescription
        }
    }
    
    private func getErrorMessageFrom(messagesArray: [Any]) -> String {
        let message = messagesArray.reduce("") { (accumulator, element) -> String in
            if let errorMsg = element as? String {
                return accumulator.appending(errorMsg + "\n")
            } else {
                return accumulator
            }
        }
        
        return message
    }
    
}
