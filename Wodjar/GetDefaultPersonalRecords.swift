//
//  GetDefaultPersonalRecords.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetDefaultPersonalRecords: BaseRequest {

    override func headerParams() -> [String : String] {
        return ["X-Api-Key": SessionManager.sharedInstance.apiKey]
    }
    
    override func requestURL() -> String {
        return "default-prs"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
}
