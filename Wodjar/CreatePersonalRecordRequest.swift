//
//  CreatePersonalRecordRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/31/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class CreatePersonalRecordRequest: BaseRequest {
    
    let personalRecord: PersonalRecord
    
    init(with personalRecord: PersonalRecord) {
        self.personalRecord = personalRecord
    }
    
    override func param() -> Dictionary<String, Any>! {
        return personalRecord.createDict()
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
    
    override func requestURL() -> String {
        return "create-pr-result/\(personalRecord.name!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
