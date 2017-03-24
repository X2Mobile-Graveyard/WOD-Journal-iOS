//
//  PersonalRecordService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

struct PersonalRecordService {
    let remoteService: PersonalRecordRemoteService
    
    // MARK: - Public Methods
    
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?) {
        if personalRecord.name == nil || personalRecord.name?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "The PR must have a name")))
            return
        }
        
        if personalRecord.result == nil || personalRecord.result?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please eneter a record")))
            return
        }
        
        remoteService.update(personalRecord: personalRecord, with: completion)
    }
    
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?) {
        if personalRecord.name == nil || personalRecord.name?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "You must enter a name")))
            return
        }
        
        if personalRecord.result == nil  || personalRecord.result?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please eneter a record")))
            return
        }
        
        remoteService.create(personalRecord: personalRecord, with: completion)
        
    }
    
    func delete(personalRecord: PersonalRecord, with completion: DeletePersonalRecordCompletion?) {
        if personalRecord.id == nil {
            completion?(.success())
            return
        }
        
        remoteService.deletePersonalRecord(with: personalRecord.id!, completion: completion)
    }
    
    // MARK: - Private Methods
    
}
