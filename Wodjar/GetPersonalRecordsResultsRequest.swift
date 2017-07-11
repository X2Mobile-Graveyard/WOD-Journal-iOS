//
//  GetPersonalRecordsResultsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetPersonalRecordsResultsRequest: BaseRequest {

    let prId: Int
    
    init(with prID: Int) {
        self.prId = prID
    }
    
    override func requestURL() -> String {
        return "pr-results/\(prId)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
