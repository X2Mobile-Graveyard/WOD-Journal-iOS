//
//  GetCustomWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetCustomWodsRequest: BaseRequest {
    override func requestURL() -> String {
        return "list-custom-wods"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
