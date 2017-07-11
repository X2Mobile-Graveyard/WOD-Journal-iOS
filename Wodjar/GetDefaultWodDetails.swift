//
//  GetDefaultWodDetails.swift
//  Wodjar
//
//  Created by Bogdan Costea on 7/5/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetDefaultWodDetails: BaseRequest {
    
    let wodId: Int
    let wodType: WODType
    
    init(with wodId: Int, wodType: WODType) {
        self.wodType = wodType
        self.wodId = wodId
    }
    
    override func requestURL() -> String {
        return "default-wods/\(wodId)/\(wodType.hash())"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }

}
