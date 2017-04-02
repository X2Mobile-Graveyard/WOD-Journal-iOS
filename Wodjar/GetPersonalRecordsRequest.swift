//
//  GetPersonalRecordsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/24/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetPersonalRecordsRequest: BaseRequest {

    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
    override func requestURL() -> String {
        return "list-prs"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
}
