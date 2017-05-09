//
//  CreateWODRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/2/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class CreateWODRequest: BaseRequest {
    let customWod: Workout
    
    init(with wod: Workout) {
        self.customWod = wod
    }
    
    override func param() -> Dictionary<String, Any>! {
        return customWod.createUpdateDict()
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPOST
    }
    
    override func requestURL() -> String {
        return "wods"
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
