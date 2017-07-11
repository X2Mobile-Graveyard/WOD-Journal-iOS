//
//  GetWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetWodsRequest: BaseRequest {
    
    let type: WODType
    init(with wodType: WODType) {
        type = wodType
    }
    
    override func requestURL() -> String {
        return "list-wods/\(type.hash())"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
