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
                let intersectedPr = self.instersect(userPersonalRecordTypes: userRecords, with: defaultPrs)
                completion?(.success(intersectedPr))
            case .failure(_):
                completion?(.success(defaultPrs))
            }
        })
    }
    
    func getPersonalRecordResult(for name: String?, with completion: GetPersonalRecordsResultsCompletion?) {
        guard let name = name else {
            completion?(.failure(NSError.localError(with: "Name of the Personal Record is invalid!")))
            return
        }
        
        remoteService.getPersonalRecords(for: name, with: completion)
    }
    
    func merge(personalRecords: [PersonalRecordType], with defaultPersonalRecords:[PersonalRecordType]) -> [PersonalRecordType] {
        return self.instersect(userPersonalRecordTypes: personalRecords, with: defaultPersonalRecords)
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        remoteService.deletePersonalRecord(with: id, completion: completion)
    }
    
    func deleteAllRecords(for personalRecordType: PersonalRecordType, with completion: DeleteAllRecordsCompletion?) {
        let personalRecordsIds = personalRecordType.records.map{$0.id!}
        remoteService.deleteRecords(with: personalRecordsIds, completion: completion)
    }
    
    func update(personalRecordsIds:[Int], with name: String, completion: UpdateRecordsNameCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.failure(NSError.localError(with: "Unable to complete operation. Please login")))
            return
        }
        
        if name.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Invalid name entered.")))
            return
        }
        
        remoteService.update(recordsIds: personalRecordsIds, with: name, completion: completion)
    }
    
    func orderByUpdatedDate(recordTypes: [PersonalRecordType]) -> [PersonalRecordType] {
        return recordTypes.sorted { (recordType1, recordType2) -> Bool in
            
            if recordType1.updatedAt.compare(recordType2.updatedAt) == .orderedAscending {
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
                    let pr = PersonalRecordType(name: personalRecordName!, present: false, defaultType: .weight, updatedAt: updatedAt!)
                    defaultPrs.append(pr)
                }
            }
            
            if let timePersonalRecords = dict["Time"] as? [[String: String]] {
                for personalRecordDict in timePersonalRecords {
                    let personalRecordName = personalRecordDict["name"]
                    let updatedAt = personalRecordDict["date"]
                    let pr = PersonalRecordType(name: personalRecordName!, present: false, defaultType: .time, updatedAt: updatedAt!)
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
}
