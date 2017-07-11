//
//  DeletePersonalRecordResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DeletePersonalRecordResultRequest: BaseRequest {
    
    let prId: Int
    
    init(with prID: Int) {
        self.prId = prID
    }
    
    override func requestURL() -> String {
        return "pr_results/\(prId)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
