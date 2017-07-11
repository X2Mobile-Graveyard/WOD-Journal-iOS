//
//  CreatePersonalRecordResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class CreatePersonalRecordResultRequest: BaseRequest {
    
    let result: PersonalRecord
    let prID: Int
    
    init(with result: PersonalRecord, prID: Int) {
        self.result = result
        self.prID = prID
    }
    
    override func param() -> Dictionary<String, Any>! {
        return result.createDict()
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
    
    override func requestURL() -> String {
        return "pr-results/\(prID)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
}
