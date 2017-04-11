//
//  WODResultRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias CreateResultCompletion = (Result<Int, NSError>) -> ()

protocol WODResultRemoteService {
    func add(result: WODResult, with completion: CreateResultCompletion?)
}

class WODResultRemoteServiceTest: WODResultRemoteService {
    func add(result: WODResult, with completion: CreateResultCompletion?) {
        completion?(.success(30))
    }
}
