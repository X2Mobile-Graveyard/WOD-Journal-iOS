//
//  UserRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias UpdateUserRequestCompletion = (Result<Void, NSError>) -> ()

protocol UserRemoteService {
    func updateUser(with name: String, pictureUrl: String?, completion: UpdateUserRequestCompletion?);
}

class UserRemoteServiceImpl: UserRemoteService {
    func updateUser(with name: String, pictureUrl: String?, completion: UpdateUserRequestCompletion?) {
        let request = UpdateUserRequest(with: name, imageURL: pictureUrl)
        
        request.success = { _, _ in
            UserManager.sharedInstance.userName = name
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
