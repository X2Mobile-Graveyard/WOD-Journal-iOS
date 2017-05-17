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
    let isDefault: Bool
    
    init(wodId: Int, isDefault: Bool) {
        self.wodId = wodId
        self.isDefault = isDefault
    }
    
    override func requestURL() -> String {
        return "wods/favorite/\(wodId)?default=\(isDefault)&favorite=\(true)"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
}
