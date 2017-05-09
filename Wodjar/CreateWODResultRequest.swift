//
//  CreateWODResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class CreateWODResultRequest: BaseRequest {
    let wodResultDictionary: [String: Any]
    
    init(with dictionary: [String: Any]) {
        self.wodResultDictionary = dictionary
    }
    
    override func param() -> Dictionary<String, Any>! {
        return wodResultDictionary
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
    
    override func requestURL() -> String {
        return "wod_results"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
}
