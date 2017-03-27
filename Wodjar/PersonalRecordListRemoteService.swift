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

protocol PersonalRecordListRemoteService {
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?)
    func getPersonalRecords(for name: String, with completion: GetPersonalRecordsResultsCompletion?)
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?)
    func deleteRecords(with ids: [Int], completion:DeleteAllRecordsCompletion?)
}

class PersonalRecordListRemoteServiceTest: PersonalRecordListRemoteService {
    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?) {
        let persRecord1 = PersonalRecordType(name: "Frecari pe cap", present: true)
        let persRecord2 = PersonalRecordType(name: "Deadlift", present: true)
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
    
    func deleteRecords(with ids: [Int], completion: DeleteAllRecordsCompletion?) {
        completion?(.success())
    }
}

class PersonalRecordListRemoteImpl: PersonalRecordListRemoteService {
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
    
    func deleteRecords(with ids: [Int], completion: DeleteAllRecordsCompletion?) {
        completion?(.success())
    }


    func getPersonalRecordsNames(with completion: GetPersonalRecordsNamesCompletion?) {
        let request = GetPersonalRecordsRequest()
        
        request.success = { _, result in
            guard let dict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            guard let prs = dict["personal_records"] as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            guard let names = prs["name"] as? [String] else {
                completion?(.failure(NSError.localError(with: "Invalid JSON")))
                return
            }
            
            var prTypes = [PersonalRecordType]()
            for name in names {
                let prType = PersonalRecordType(name: name, present: true)
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
