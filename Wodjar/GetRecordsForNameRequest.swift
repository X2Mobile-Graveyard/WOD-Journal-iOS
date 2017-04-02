//
//  GetRecordsForNameRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetRecordsForNameRequest: BaseRequest {
    
    let personalRecordName: String
    
    init(with name: String) {
        personalRecordName = name
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func requestURL() -> String {
        return "list-prs-by-name/\(personalRecordName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
