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
    
    func update(personalRecord: PersonalRecord, with imagePath: String?, completion: UpdatePersonalRecordCompletion?) {
        if personalRecord.name == nil || personalRecord.name?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "The PR must have a name")))
            return
        }
        
        if personalRecord.result == nil || personalRecord.result?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please eneter a record")))
            return
        }
        
        guard let imagePath = imagePath else {
            remoteService.update(personalRecord: personalRecord, with: completion)
            return
        }
        
        guard let url = URL(string: imagePath) else {
            remoteService.update(personalRecord: personalRecord, with: completion)
            return
        }
        
        if personalRecord.imageUrl == nil {
            remoteService.uploadImage(with: url, key: nil) { (result) in
                switch result {
                case let .success(s3Path):
                    personalRecord.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.update(personalRecord: personalRecord, with: completion)
            }
            
            return
        }
        
        if let key = personalRecord.imageUrl?.components(separatedBy: "/").last {
            remoteService.uploadImage(with: url, key: key) { (result) in
                switch result {
                case let .success(s3Path):
                    personalRecord.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.update(personalRecord: personalRecord, with: completion)
            }
        } else {
            remoteService.uploadImage(with: url, key: nil) { (result) in
                switch result {
                case let .success(s3Path):
                    personalRecord.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.update(personalRecord: personalRecord, with: completion)
            }
        }
    }
    
    func create(personalRecord: PersonalRecord, with imagePath: String?,  completion: CreatePersonalRecordCompletion?) {
        if personalRecord.name == nil || personalRecord.name?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "You must enter a name")))
            return
        }
        
        if personalRecord.result == nil  || personalRecord.result?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please eneter a record")))
            return
        }
        
        if imagePath == nil {
            remoteService.create(personalRecord: personalRecord, with: completion)
            return
        }
        
        guard let url = URL(string: imagePath!) else {
            remoteService.create(personalRecord: personalRecord, with: completion)
            return
        }
        
        remoteService.uploadImage(with: url, key: nil) { (result) in
            switch result {
            case let .success(s3Path):
                personalRecord.imageUrl = s3Path
            case .failure(_):
                break
            }
            
            self.remoteService.create(personalRecord: personalRecord, with: completion)
        }
    }
    
    func delete(personalRecord: PersonalRecord, with completion: DeletePersonalRecordCompletion?) {
        if personalRecord.id == nil {
            completion?(.success())
            return
        }
        
        if personalRecord.imageUrl == nil {
            remoteService.deletePersonalRecord(with: personalRecord.id!, completion: completion)
            return
        }
        
        if let key = personalRecord.imageUrl?.components(separatedBy: "/").last {
            remoteService.deleteImage(with: key, completion: { (result) in
                self.remoteService.deletePersonalRecord(with: personalRecord.id!, completion: completion)
            })
        }
    }
}
