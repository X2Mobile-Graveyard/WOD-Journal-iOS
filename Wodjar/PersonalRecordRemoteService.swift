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
typealias UploadImageRequestCompletion = (Result<String, NSError>) -> ()
typealias DeleteImageRequestCompletion = (Result<Void, NSError>) -> ()

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

class PersonalRecordRemoteServiceImpl: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?) {
        let request = UpdatePersonalRecordRequest(with: personalRecord)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?) {
        let request = CreatePersonalRecordRequest(with: personalRecord)
        
        request.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Error. Please try again.")))
                return
            }
            
            guard let id = response["id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Error. Please try again.")))
                return
            }
            
            completion?(.success(id))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        let request = DeletePersonalRecordRequest(with: [id])
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
