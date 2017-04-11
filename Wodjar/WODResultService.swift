//
//  WODResultService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

struct WODResultService {
    let remote: WODResultRemoteService
    
    func add(result: WODResult, with completion: CreateResultCompletion?) {
        remote.add(result: result, with: completion)
    }
}
