//
//  GetWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetWodsRequest: BaseRequest {
    
    override func requestURL() -> String {
        return "list-wods"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        if UserManager.sharedInstance.isAuthenticated() {
            return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
        }
        
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }

}