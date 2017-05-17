//
//  PersonalRecordService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import SDWebImage

struct PersonalRecordService {
    let remoteService: PersonalRecordRemoteService
    let s3RemoteService: S3RemoteService
    var recordsNames: [String]? = nil
    
    // MARK: - Public Methods
    
    func update(personalRecord: PersonalRecord, with imagePath: String?, completion: UpdatePersonalRecordCompletion?) {
        if personalRecord.name == nil || personalRecord.name?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "The PR must have a name")))
            return
        }
        
        if personalRecord.resultAsString() == nil || personalRecord.resultAsString()?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a record")))
            return
        }
        
        guard let imagePath = imagePath else {
            if personalRecord.imageUrl == nil {
                remoteService.update(personalRecord: personalRecord, with: completion)
                return
            }
            
            if let key = personalRecord.imageUrl?.components(separatedBy: "/").last {
                s3RemoteService.deleteImage(with: key, completion: { (result) in
                    personalRecord.imageUrl = nil
                    self.remoteService.update(personalRecord: personalRecord, with: completion)
                })
            }
            return
        }
        
        let url = URL(fileURLWithPath: imagePath)
        
        if personalRecord.imageUrl == nil {
            s3RemoteService.uploadImage(with: url, key: nil) { (result) in
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
        
        if imagePath.contains("amazonaws") {
            remoteService.update(personalRecord: personalRecord, with: completion)
            return
        }
        
        if let key = personalRecord.imageUrl?.components(separatedBy: "/").last {
            if let s3URL = URL(string: personalRecord.imageUrl!) {
                SDImageCache.shared().removeImage(forKey:s3URL.absoluteString, withCompletion: nil)
            }
            s3RemoteService.uploadImage(with: url, key: key) { (result) in
                switch result {
                case let .success(s3Path):
                    personalRecord.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.update(personalRecord: personalRecord, with: completion)
            }
        } else {
            s3RemoteService.uploadImage(with: url, key: nil) { (result) in
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
        
        if let names = recordsNames {
            if names.contains(personalRecord.name!) {
                completion?(.failure(NSError.localError(with: "You already have records with the same name.")))
                return
            }
        }
        
        if personalRecord.resultAsString() == nil || personalRecord.resultAsString()?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a record")))
            return
        }
        
        if imagePath == nil {
            remoteService.create(personalRecord: personalRecord, with: completion)
            return
        }
        
        let url = URL(fileURLWithPath: imagePath!)
        s3RemoteService.uploadImage(with: url, key: nil) { (result) in
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
            s3RemoteService.deleteImage(with: key, completion: { (result) in
                self.remoteService.deletePersonalRecord(with: personalRecord.id!, completion: completion)
            })
        }
    }
}
