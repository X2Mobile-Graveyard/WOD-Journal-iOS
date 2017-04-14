//
//  WODRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias UpdateWodCompletion = (Result<Void, NSError>) -> ()
typealias CreateWodCompletion = (Result<Int, NSError>) -> ()

protocol WODRemoteService {
    func update(wod: Workout, with: UpdateWodCompletion?)
    func create(customWod: Workout, with: CreateWodCompletion?)
}

class WODRemoteServiceTest: WODRemoteService {
    func update(wod: Workout, with completion: UpdateWodCompletion?) {
        completion?(.success())
    }
    
    func create(customWod: Workout, with completion: CreateWodCompletion?) {
        completion?(.success(40))
    }
}
