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
    let ids: [Int]
    
    init(with ids:[Int], name: String) {
        self.name = name
        self.ids = ids
    }
    
    override func arrayParam() -> Any? {
        return ids
    }
    
    override func requestURL() -> String {
        return "update-prs/\(name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
