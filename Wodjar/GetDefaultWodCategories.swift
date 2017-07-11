//
//  GetDefaultWodCategories.swift
//  Wodjar
//
//  Created by Bogdan Costea on 6/27/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetDefaultWodCategories: BaseRequest {
    override func requestURL() -> String {
        return "list-categories-unlogged"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["X-Api-Key":SessionManager.sharedInstance.apiKey]
    }
}
