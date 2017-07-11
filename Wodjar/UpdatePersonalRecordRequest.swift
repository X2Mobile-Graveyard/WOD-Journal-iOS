//
//  UpdatePersonalRecordRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/31/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdatePersonalRecordRequest: BaseRequest {

    let personalRecord: PersonalRecord
    
    init(with personalRecord: PersonalRecord) {
        self.personalRecord = personalRecord
    }
    
    override func param() -> Dictionary<String, Any>! {
        return ["personal_record":self.personalRecord.updateDict()]
    }
    
    override func requestURL() -> String {
        return "personal_records/\(personalRecord.id!)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
