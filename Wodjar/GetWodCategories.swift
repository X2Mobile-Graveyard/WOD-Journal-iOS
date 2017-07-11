//
//  GetWodCategories.swift
//  Wodjar
//
//  Created by Bogdan Costea on 6/26/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetWodCategories: BaseRequest {
    override func requestURL() -> String {
        return "list-categories"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
