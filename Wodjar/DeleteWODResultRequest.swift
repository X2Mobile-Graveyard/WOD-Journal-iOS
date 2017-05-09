//
//  DeleteWODResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DeleteWODResultRequest: BaseRequest {

    let resultId: Int
    
    init(resultId: Int) {
        self.resultId = resultId
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodDELETE
    }
    
    override func requestURL() -> String {
        return "wod_results/\(resultId)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
