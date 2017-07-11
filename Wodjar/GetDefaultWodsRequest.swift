//
//  GetDefaultWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/2/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetDefaultWodsRequest: BaseRequest {

    let type: WODType
    init(with wodType: WODType) {
        type = wodType
    }
    
    override func requestURL() -> String {
        return "list-default-wods/\(type.hash())"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }
}
