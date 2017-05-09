//
//  AddToFavoriteRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/3/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class AddToFavoriteRequest: BaseRequest {
    
    let wodId: Int
    
    init(wodId: Int) {
        self.wodId = wodId
    }
    
    override func requestURL() -> String {
        return "add-favorite/\(wodId)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
}