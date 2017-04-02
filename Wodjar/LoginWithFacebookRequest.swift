//
//  LoginWithFacebookRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/28/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class LoginWithFacebookRequest: BaseRequest {
    
    let accessToken: String
    
    init(with accessToken: String) {
        self.accessToken = accessToken
    }
    
    override func param() -> Dictionary<String, Any>! {
        return ["access_token": accessToken]
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func requestURL() -> String {
        return "facebook-sign-in"
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }
}
