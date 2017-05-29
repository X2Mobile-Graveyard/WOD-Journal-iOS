//
//  RegisterRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class RegisterRequest: BaseRequest {
    
    let email: String
    let password: String
    let name: String
    let imageUrl: String?
    
    init(with email: String, password: String, name: String, imageUrl: String?) {
        self.email = email
        self.password = password
        self.name = name
        self.imageUrl = imageUrl
    }
    
    override func param() -> Dictionary<String, Any>! {
        return ["user":["email": email,
                        "password": password,
                        "password_confirmation": password,
                        "name": name,
                        "image_url": imageUrl]]
    }
    
    override func requestURL() -> String {
        return "users"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }
}
