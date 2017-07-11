//
//  UpdatePersonalRecordResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdatePersonalRecordResultRequest: BaseRequest {
    let personalRecord: PersonalRecord
    
    init(with personalRecord: PersonalRecord) {
        self.personalRecord = personalRecord
    }
    
    override func param() -> Dictionary<String, Any>! {
        return self.personalRecord.updateDict()
    }
    
    override func requestURL() -> String {
        return "pr_results/\(personalRecord.id!)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
