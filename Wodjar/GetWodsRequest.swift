//
//  GetWodsRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class GetWodsRequest: BaseRequest {
    
    override init() {
        super.init()
        #if !((arch(i386) || arch(x86_64)) && os(iOS))
            guard let status = Network.reachability?.status else {
                return
            }
            if status == .unreachable {
                self.useCachePolicy = true
            }
        #endif
    }
    
    override func requestURL() -> String {
        return "list-wods"
    }
    
    override func requestMethod() -> RequestMethod {
        return .RequestMethodGET
    }
    
    override func headerParams() -> [String : String] {
        return ["Authorization":"Token \(UserManager.sharedInstance.userToken!)"]
    }
}
