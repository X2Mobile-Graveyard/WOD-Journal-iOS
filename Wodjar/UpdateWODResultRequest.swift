//
//  UpdateWODResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdateWODResultRequest: BaseRequest {
    let wodResultDictionary: [String: Any]
    
    init(with dictionary: [String: Any]) {
        self.wodResultDictionary = dictionary
    }
    
    override func param() -> Dictionary<String, Any>! {
        return wodResultDictionary
    }
    
    override func requestURL() -> String {
        return "wod_results/\(wodResultDictionary["id"]!)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
