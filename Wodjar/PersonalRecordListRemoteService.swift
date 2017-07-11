//
//  PersonalRecordListRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias GetPersonalRecordsNamesCompletion = (Result<[PersonalRecordType], NSError>) -> ()
typealias GetPersonalRecordsResultsCompletion = (Result<[PersonalRecord], NSError>) -> ()

protocol PersonalRecordListRemoteService {
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?)
    func getPersonalRecords(for id: Int, with completion: GetPersonalRecordsResultsCompletion?)
    func deletePersonalRecord(with id: Int, completion: VoidRequestCompletion?)
    func deletePersonalRecordResult(with id: Int, completion: VoidRequestCompletion?)
    func update(personalRecordTypeId: Int, with name: String, completion: VoidRequestCompletion?)
}

class PersonalRecordListRemoteServiceTest: PersonalRecordListRemoteService {
    func deletePersonalRecordResult(with id: Int, completion: VoidRequestCompletion?) {
        completion?(.success())
    }
    
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?) {
        let persRecord1 = PersonalRecordType(name: "Frecari pe cap", present: true, updatedAt: "2015-01-10")
        let persRecord2 = PersonalRecordType(name: "Deadlift", present: true, updatedAt: "2015-01-10")
        completion?(.success([persRecord1, persRecord2]))
    }
    
    func getPersonalRecords(for id: Int, with completion: GetPersonalRecordsResultsCompletion?) {
        let persRecord1 = PersonalRecord(name: "asf", rx: true, result: "23", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        let persRecord2 = PersonalRecord(name: "ASf", rx: true, result: "54", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        let persRecord3 = PersonalRecord(name: "Asfaf", rx: true, result: "67", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        persRecord1.id = 1
        persRecord2.id = 2
        persRecord3.id = 3
        
        completion?(.success([persRecord1, persRecord2, persRecord3]))
    }
    
    func deletePersonalRecord(with id: Int, completion: VoidRequestCompletion?) {
        completion?(.success())
    }
    
    func update(personalRecordTypeId: Int, with name: String, completion: VoidRequestCompletion?) {
        completion?(.success())
    }
}

class PersonalRecordListRemoteImpl: PersonalRecordListRemoteService {
    
    func deletePersonalRecordResult(with id: Int, completion: VoidRequestCompletion?) {
        let request = DeletePersonalRecordResultRequest(with: id)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func getPersonalRecords(for id: Int, with completion: GetPersonalRecordsResultsCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.success([]))
            return
        }
        
        let request = GetPersonalRecordsResultsRequest(with: id)
        
        request.success = { _, result in
            guard let recordsArray = result as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            var records = [PersonalRecord]()
            for recordDictionary in recordsArray {
                let personalRecord = PersonalRecord(with: recordDictionary)
                records.append(personalRecord)
            }
            
            completion?(.success(records))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func deletePersonalRecord(with id: Int, completion: VoidRequestCompletion?) {
        let request = DeletePersonalRecordRequest(with: id)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        
        request.runRequest()
    }

    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            getDefaultRecords(with: completion)
            return
        }
        
        let request = GetPersonalRecordsRequest()
        
        request.success = { _, result in
            guard let prs = result as? [[String: Any]] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            var prTypes = [PersonalRecordType]()
            for prTypeDict in prs {
                let prType = PersonalRecordType(with: prTypeDict)
                prTypes.append(prType)
            }
            
            completion?(.success(prTypes))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func update(personalRecordTypeId: Int, with name: String, completion: VoidRequestCompletion?) {
        let request = UpdateRecordsNameRequest(with: personalRecordTypeId, name: name)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getDefaultRecords(with completion: GetPersonalRecordsNamesCompletion?) {
        let request = GetDefaultPersonalRecords()
        
        request.success = { _, result in
            guard let dict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            guard let prs = dict["default_prs"] as? [[String: Any]] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            
            var prTypes = [PersonalRecordType]()
            for prTypeDict in prs {
                let prType = PersonalRecordType(with: prTypeDict)
                prTypes.append(prType)
            }
            
            completion?(.success(prTypes))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
