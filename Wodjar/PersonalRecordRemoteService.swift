//
//  PersonalRecordRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias CreatePersonalRecordTypeCompletion = (Result<(Int, Int), NSError>) -> ()
typealias CreatePersonalRecordResultCompletion = (Result<Int, NSError>) -> ()
typealias UploadImageRequestCompletion = (Result<String, NSError>) -> ()
typealias VoidRequestCompletion = (Result<Void, NSError>) -> ()

protocol PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord,
                with completion: VoidRequestCompletion?)
    
    func create(personalRecord: PersonalRecord,
                with completion: CreatePersonalRecordTypeCompletion?)
    
    func deletePersonalRecord(with id: Int,
                              completion: VoidRequestCompletion?)
    
    func createResult(result: PersonalRecord,
                      for personalRecordType: PersonalRecordType,
                      with completion: CreatePersonalRecordResultCompletion?)
}

class PersonalRecordRemoteServiceTest: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord,
                with completion: VoidRequestCompletion?) {
        completion?(.success())
    }
    
    func create(personalRecord: PersonalRecord,
                with completion: CreatePersonalRecordTypeCompletion?) {
        completion?(.success((5,5)))
    }
    
    func deletePersonalRecord(with id: Int,
                              completion: VoidRequestCompletion?) {
        completion?(.success())
    }
    
    func createResult(result: PersonalRecord,
                      for personalRecordType: PersonalRecordType,
                      with completion: CreatePersonalRecordResultCompletion?) {
        completion?(.success(5))
    }
}

class PersonalRecordRemoteServiceImpl: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord,
                with completion: VoidRequestCompletion?) {
        let request = UpdatePersonalRecordResultRequest(with: personalRecord)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func createResult(result: PersonalRecord,
                      for personalRecordType: PersonalRecordType,
                      with completion: CreatePersonalRecordResultCompletion?) {
        let request = CreatePersonalRecordResultRequest(with: result, prID: personalRecordType.id)
        
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
    
    func create(personalRecord: PersonalRecord,
                with completion: CreatePersonalRecordTypeCompletion?) {
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
            
            guard let prID = response["personal_record_id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Error. Please try again.")))
                return
            }
            
            completion?(.success((id, prID)))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func deletePersonalRecord(with id: Int,
                              completion: VoidRequestCompletion?) {
        let request = DeletePersonalRecordResultRequest(with: id)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
