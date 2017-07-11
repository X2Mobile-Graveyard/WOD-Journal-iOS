//
//  UpdateRecordsNameRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/31/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdateRecordsNameRequest: BaseRequest {
    
    let name: String
    let id: Int
    
    init(with id:Int, name: String) {
        self.name = name
        self.id = id
    }
    
    override func arrayParam() -> Any? {
        return ["name":name]
    }
    
    override func requestURL() -> String {
        return "personal_records/\(id)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
