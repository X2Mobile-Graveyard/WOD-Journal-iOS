//
//  PersonalRecordListService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

struct PersonalRecordListService {
    let remoteService: PersonalRecordListRemoteService
    
    // MARK: - Public Methods
    
    func getPersonalRecordTypes(with completion: GetPersonalRecordsNamesCompletion?) {
        
        remoteService.getPersonalRecordsNames(with: { (result) in
            let defaultPrs = self.getDefaultPersonalRecordTypes()
            switch result {
            case let .success(userRecords):
                completion?(.success(userRecords))
            case .failure(_):
                completion?(.success(defaultPrs))
            }
        })
    }
    
    func getPersonalRecordResult(for id: Int, with completion: GetPersonalRecordsResultsCompletion?) {
        remoteService.getPersonalRecords(for: id) { (result) in
            switch result {
            case let .success(prResults):
                if prResults.count > 0 {
                    completion?(.success(prResults.sorted(by: { (r1, r2) -> Bool in
                        return (r1.date.compare(r2.date) == .orderedDescending)
                    })))
                    return
                }
                completion?(.success(prResults))
            case let .failure(error):
                completion?(.failure(error))
            }

        }
    }
    
    func merge(personalRecords: [PersonalRecordType], with defaultPersonalRecords:[PersonalRecordType]) -> [PersonalRecordType] {
        return self.instersect(userPersonalRecordTypes: personalRecords, with: defaultPersonalRecords)
    }
    
    func deletePersonalRecord(with id: Int, completion: VoidRequestCompletion?) {
        remoteService.deletePersonalRecord(with: id, completion: completion)
    }
    
    func deletePersonalRecordResult(with id: Int, completion: VoidRequestCompletion?) {
        remoteService.deletePersonalRecordResult(with: id, completion: completion)
    }
    
    func deleteAllRecords(for personalRecordType: PersonalRecordType, with completion: VoidRequestCompletion?) {
        remoteService.deletePersonalRecord(with: personalRecordType.id, completion: completion)
    }
    
    func update(personalRecordTypeId:Int, with name: String, completion: VoidRequestCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.failure(NSError.localError(with: "Unable to complete operation. Please login")))
            return
        }
        
        if name.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Invalid name entered.")))
            return
        }
        
        remoteService.update(personalRecordTypeId: personalRecordTypeId, with: name, completion: completion)
    }
    
    func orderByUpdatedDate(recordTypes: [PersonalRecordType]) -> [PersonalRecordType] {
        return recordTypes.sorted { (recordType1, recordType2) -> Bool in
            
            if recordType1.updatedAt.timeIntervalSince1970 < recordType2.updatedAt.timeIntervalSince1970 {
                return false
            }
            
            return true
        }
    }
    
    // MARK: - Private Methods
    
    private func getDefaultPersonalRecordTypes() -> [PersonalRecordType] {
        var defaultPrs = [PersonalRecordType]()
        if let path = Bundle.main.path(forResource: "defaultPRs", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            if let weightPersonalRecords = dict["Weight"] as? [[String: String]] {
                for personalRecordDict in weightPersonalRecords {
                    let personalRecordName = personalRecordDict["name"]
                    let updatedAt = personalRecordDict["date"]
                    let pr = PersonalRecordType(id: 2,
                                                name: personalRecordName!,
                                                present: false,
                                                defaultType: .weight,
                                                updatedAt: updatedAt!)
                    defaultPrs.append(pr)
                }
            }
            
            if let timePersonalRecords = dict["Time"] as? [[String: String]] {
                for personalRecordDict in timePersonalRecords {
                    let personalRecordName = personalRecordDict["name"]
                    let updatedAt = personalRecordDict["date"]
                    let pr = PersonalRecordType(id: 2,
                                                name: personalRecordName!,
                                                present: false,
                                                defaultType: .time,
                                                updatedAt: updatedAt!)
                    defaultPrs.append(pr)
                }
            }
        }
        
        return defaultPrs
    }
    
    private func instersect(userPersonalRecordTypes: [PersonalRecordType],
                            with defaultPersonalRecordTypes:[PersonalRecordType]) ->[PersonalRecordType] {
        var intersectedPrsTypes = userPersonalRecordTypes
        let personalPrTypeNames = intersectedPrsTypes.map {$0.name}
        
        for defaultPrType in defaultPersonalRecordTypes {
            if personalPrTypeNames.contains(where: {$0 == defaultPrType.name!}) {
                continue
            }
            
            intersectedPrsTypes.append(defaultPrType)
        }
        
        return intersectedPrsTypes
    }
    
    func sortResultsByDate(result: [PersonalRecord]) -> [PersonalRecord] {
        return result.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
    }
}
