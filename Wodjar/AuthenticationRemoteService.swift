//
//  AuthenticationRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias RegularLoginCompletion = (Result<Void, NSError>) -> ()
typealias FacebookLoginCompletion = (Result<Void, NSError>) -> ()
typealias RegisterCompletion = (Result<Int, NSError>) -> ()

protocol AuthenticationRemoteService {
    func registerUser(with email: String, password: String, name: String, imageUrl: String?, completion: RegisterCompletion?)
    func facebookLogin(with token: String, completion: FacebookLoginCompletion?)
    func regularLogin(with email: String, password: String, completion: RegularLoginCompletion?)
}

class AuthenticationRemoteServiceImpl: AuthenticationRemoteService {
    func registerUser(with email: String, password: String, name: String, imageUrl: String?, completion: RegisterCompletion?) {
        let registerRequest = RegisterRequest(with: email, password: password, name: name, imageUrl:imageUrl)
        
        registerRequest.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Register failed")))
                return
            }
            
            guard let userId = response["id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Register failed")))
                return
            }
            
            completion?(.success(userId))
        }
        
        registerRequest.error = { request, error in
            completion?(.failure(error))
        }
        
        registerRequest.runRequest()
    }
    
    func regularLogin(with email: String, password: String, completion: RegularLoginCompletion?) {
        let loginRequest = LoginRequest(email: email, password: password)
        
        loginRequest.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            guard let token = response["auth_token"]  as? String else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            guard let userId = response["user_id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            UserManager.sharedInstance.userId = userId
            UserManager.sharedInstance.userToken = token
            
            if let imageUrl = response["user_image_url"] as? String {
                UserManager.sharedInstance.imageUrl = imageUrl
            }
            
            if UserManager.sharedInstance.imageUrl == "" {
                UserManager.sharedInstance.imageUrl = nil
            }
            
            if let name = response["user_name"] as? String {
                UserManager.sharedInstance.userName = name
            }
            
            if let email = response["user_email"] as? String {
                UserManager.sharedInstance.email = email
            }
            
            completion?(.success())
        }
        
        loginRequest.error = { request, error in
            completion?(.failure(error))
        }
        
        loginRequest.runRequest()
    }
    
    func facebookLogin(with token: String, completion: FacebookLoginCompletion?) {
        let facebookRequest = LoginWithFacebookRequest(with: token)
        
        facebookRequest.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            guard let token = response["auth_token"] as? String else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            guard let userId = response["user_id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Unable to sign in")))
                return
            }
            
            UserManager.sharedInstance.userId = userId
            UserManager.sharedInstance.userToken = token
            
            if let imageUrl = response["user_image_url"] as? String {
                UserManager.sharedInstance.imageUrl = imageUrl
            }
            
            if UserManager.sharedInstance.imageUrl == "" {
                UserManager.sharedInstance.imageUrl = nil
            }
            
            if let name = response["user_name"] as? String {
                UserManager.sharedInstance.userName = name
            }
            
            if let email = response["user_email"] as? String {
                UserManager.sharedInstance.email = email
            }

            
            completion?(.success())
        }
        
        facebookRequest.error = { _, error in
            completion?(.failure(error))
        }
        
        facebookRequest.runRequest()
    }
}

class AuthenticationRemoteServiceTest: AuthenticationRemoteService {
    func regularLogin(with email: String, password: String, completion: RegularLoginCompletion?) {
        completion?(.success())
    }
    
    func registerUser(with email: String, password: String, name: String, imageUrl: String?, completion: RegisterCompletion?) {
        completion?(.success(5))
    }
    
    func facebookLogin(with token: String, completion: FacebookLoginCompletion?) {
        completion?(.success())
    }
}
