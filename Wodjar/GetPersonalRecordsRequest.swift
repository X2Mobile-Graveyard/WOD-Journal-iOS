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
        return ["Authorization":"Token 66c168e57284db615f3c71c19a8d83e8"];
    }
    
    override func requestURL() -> String {
        return "list-prs"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
}
