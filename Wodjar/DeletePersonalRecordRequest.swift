//
//  DeletePersonalRecordRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DeletePersonalRecordRequest: BaseRequest {

    let recordId: Int
    
    init(with id:Int) {
        self.recordId = id
    }
    
    override func requestURL() -> String {
        return "personal_records/\(recordId)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
