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
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
