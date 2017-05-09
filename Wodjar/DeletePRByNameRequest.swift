//
//  DeletePRByNameRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/24/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DeletePRByNameRequest: BaseRequest {

    let personalRecordName: String
    
    init(recordName: String) {
        self.personalRecordName = recordName
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
    override func requestURL() -> String {
        return "delete-prs-by-name/\(personalRecordName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
