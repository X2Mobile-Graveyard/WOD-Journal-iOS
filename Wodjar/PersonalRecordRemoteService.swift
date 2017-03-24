//
//  PersonalRecordRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias CreatePersonalRecordCompletion = (Result<Int, NSError>) -> ()
typealias UpdatePersonalRecordCompletion = (Result<Void, NSError>) -> ()
typealias DeletePersonalRecordCompletion = (Result<Void, NSError>) -> ()

protocol PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?)
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?)
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?)
}

class PersonalRecordRemoteServiceTest: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?) {
        completion?(.success())
    }
    
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?) {
        completion?(.success(5))
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        completion?(.success())
    }
}
