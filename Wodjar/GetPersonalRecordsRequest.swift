//
//  GetPersonalRecordsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/24/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetPersonalRecordsRequest: BaseRequest {

    override init() {
        super.init()
        #if !(TARGET_OS_SIMULATOR)
        guard let status = Network.reachability?.status else {
            return
        }
        if status == .unreachable {
            self.useCachePolicy = true
        }
        #endif
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
    
    override func requestURL() -> String {
        return "list-prs"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
}
