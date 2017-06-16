//
//  UpdateUserRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdateUserRequest: BaseRequest {

    let imageURL: String?
    let name: String
    
    init(with name: String, imageURL: String?) {
        self.imageURL = imageURL
        self.name = name
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }

    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func param() -> Dictionary<String, Any>! {
        if imageURL != nil {
            return ["image_url":imageURL!, "name":name]
        }
        return ["name":name]
        
    }
    
    override func requestURL() -> String {
        return "users/\(UserManager.sharedInstance.userId!)"
    }
}
