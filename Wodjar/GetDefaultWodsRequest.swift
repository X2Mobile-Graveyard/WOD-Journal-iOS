//
//  GetDefaultWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/2/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetDefaultWodsRequest: BaseRequest {

    override func requestURL() -> String {
        return "default-wods"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }
}
