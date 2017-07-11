//
//  GetCustomWodDetailsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetCustomWodDetailsRequest: BaseRequest {
    let wodId: Int
    
    init(with wodId: Int) {
        self.wodId = wodId
    }
    
    override func requestURL() -> String {
        return "custom-wods/\(wodId))"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
