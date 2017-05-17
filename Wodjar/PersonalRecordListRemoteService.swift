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
typealias DeleteAllRecordsCompletion = (Result<Void, NSError>) -> ()
typealias UpdateRecordsNameCompletion = (Result<Void, NSError>) -> ()

protocol PersonalRecordListRemoteService {
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?)
    func getPersonalRecords(for name: String, with completion: GetPersonalRecordsResultsCompletion?)
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?)
    func deleteRecords(with name: String, completion: DeleteAllRecordsCompletion?)
    func update(recordsIds:[Int], with: String, completion: UpdateRecordsNameCompletion?)
    func deletePersonalRecord(with name: String, completion: DeletePersonalRecordCompletion?)
}

class PersonalRecordListRemoteServiceTest: PersonalRecordListRemoteService {
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?) {
        let persRecord1 = PersonalRecordType(name: "Frecari pe cap", present: true, updatedAt: "2015-01-10")
        let persRecord2 = PersonalRecordType(name: "Deadlift", present: true, updatedAt: "2015-01-10")
        completion?(.success([persRecord1, persRecord2]))
    }
    
    func getPersonalRecords(for name: String, with completion: GetPersonalRecordsResultsCompletion?) {
        let persRecord1 = PersonalRecord(name: name, rx: true, result: "23", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        let persRecord2 = PersonalRecord(name: name, rx: true, result: "54", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        let persRecord3 = PersonalRecord(name: name, rx: true, result: "67", resultType: .weight, unitType: .imperial, notes: "", imageUrl: nil, date: Date())
        persRecord1.id = 1
        persRecord2.id = 2
        persRecord3.id = 3
        
        completion?(.success([persRecord1, persRecord2, persRecord3]))
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        completion?(.success())
    }
    
    func deleteRecords(with name: String, completion: DeleteAllRecordsCompletion?) {
        completion?(.success())
    }
    
    func update(recordsIds: [Int], with: String, completion: UpdateRecordsNameCompletion?) {
        completion?(.success())
    }
    
    func deletePersonalRecord(with name: String, completion: DeletePersonalRecordCompletion?) {
        completion?(.success())
    }
}

class PersonalRecordListRemoteImpl: PersonalRecordListRemoteService {
    func getPersonalRecords(for name: String, with completion: GetPersonalRecordsResultsCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.success([]))
            return
        }
        
        let request = GetRecordsForNameRequest(with: name)
        
        request.success = { _, result in
            guard let result = result as? [String: Any] else {
                completion?(.success([]))
                return
            }
            
            guard let recordsArray = result["personal_records"] as? [[String: Any]] else {
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
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        let request = DeletePersonalRecordRequest(with: id)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        
        request.runRequest()
    }
    
    func deleteRecords(with name: String, completion: DeleteAllRecordsCompletion?) {
        let request = DeletePRByNameRequest(recordName: name)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        
        request.runRequest()
    }

    func deletePersonalRecord(with name: String, completion: DeletePersonalRecordCompletion?) {
        let request = DeletePRByNameRequest(recordName: name)
        
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
            guard let dict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            guard let prs = dict["personal_records"] as? [[String: Any]] else {
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
    
    func update(recordsIds: [Int], with name: String, completion: UpdateRecordsNameCompletion?) {
        let request = UpdateRecordsNameRequest(with: recordsIds, name: name)
        
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
