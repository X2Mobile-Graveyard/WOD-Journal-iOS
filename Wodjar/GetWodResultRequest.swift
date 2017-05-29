//
//  GetWodResultRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetWodResultRequest: BaseRequest {
    
    var wodId: Int
    
    init(with wodId: Int) {
        self.wodId = wodId
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
    
    override func requestURL() -> String {
        return "list-wrs-by-wod/\(wodId)"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
