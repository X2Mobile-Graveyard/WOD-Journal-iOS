//
//  UpdateWodRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/2/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UpdateWodRequest: BaseRequest {
    let customWod: Workout
    
    init(with customWod: Workout) {
        self.customWod = customWod
    }
    
    override func param() -> Dictionary<String, Any>! {
        return self.customWod.createUpdateDict()
    }
    
    override func requestURL() -> String {
        return "wods/\(customWod.id!)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodPUT
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"];
    }
}
