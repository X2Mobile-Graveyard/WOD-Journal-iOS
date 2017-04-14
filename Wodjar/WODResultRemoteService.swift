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
typealias UpdateResultCompletion = (Result<Void, NSError>) -> ()
typealias DeleteResultCompletion = (Result<Void, NSError>) -> ()

protocol WODResultRemoteService {
    func add(result: WODResult, with completion: CreateResultCompletion?)
    func update(result: WODResult, with completion: UpdateResultCompletion?)
    func delete(result: WODResult, with completion: DeleteResultCompletion?)
}

class WODResultRemoteServiceTest: WODResultRemoteService {
    func add(result: WODResult, with completion: CreateResultCompletion?) {
        completion?(.success(30))
    }
    
    func update(result: WODResult, with completion: UpdateResultCompletion?) {
        completion?(.success())
    }
    
    func delete(result: WODResult, with completion: DeleteResultCompletion?) {
        completion?(.success())
    }
}
