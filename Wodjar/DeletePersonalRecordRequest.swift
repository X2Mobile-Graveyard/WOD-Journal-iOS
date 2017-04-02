//
//  DeletePersonalRecordRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DeletePersonalRecordRequest: BaseRequest {

    let recordIds: [Int]
    
    init(with ids:[Int]) {
        self.recordIds = ids
    }
    
    override func requestURL() -> String {
        return "delete-prs"
    }
    
    override func param() -> Dictionary<String, Any>! {
        return ["personal_records":["ids":recordIds]]
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
