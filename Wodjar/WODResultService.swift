//
//  WODResultService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import SDWebImage

struct WODResultService {
    let remote: WODResultRemoteService
    let s3Remote: S3RemoteService
    
    func add(wodResult: WODResult, for wod: Workout, with picturePath: String?, completion: CreateResultCompletion?) {
        if wodResult.resultAsString() == nil || wodResult.resultAsString()?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a result.")))
            return
        }
        
        guard let picturePath = picturePath  else {
            remote.add(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
            return
        }
        
        let url = URL(fileURLWithPath: picturePath)
        s3Remote.uploadImage(with: url, key: nil) { (result) in
            switch result {
            case let .success(s3Path):
                wodResult.photoUrl = s3Path
            case .failure(_):
                break
            }
            
            self.remote.add(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
        }
    }
    
    func update(wodResult: WODResult, for wod: Workout, with picturePath: String?, completion: VoidRequestCompletion?) {
        if wodResult.resultAsString() == nil || wodResult.resultAsString()?.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "Please enter a result.")))
            return
        }
        
        guard let picturePath = picturePath  else {
            if wodResult.photoUrl == nil {
                remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
                return
            }
            
            if let key = wodResult.photoUrl?.components(separatedBy: "/").last {
                s3Remote.deleteImage(with: key, completion: { (result) in
                    wodResult.photoUrl = nil
                    self.remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
                })
            }
            return
        }
        
        let url = URL(fileURLWithPath: picturePath)
        if wodResult.photoUrl == nil {
            s3Remote.uploadImage(with: url, key: nil, completion: { (result) in
                switch result {
                case let .success(s3Path):
                    wodResult.photoUrl = s3Path
                case .failure(_):
                    break
                }
                self.remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
            })
            return
        }
        
        if picturePath.contains("amazonaws") {
            remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
            return
        }
        
        if let key = wodResult.photoUrl?.components(separatedBy: "/").last {
            if let s3URL = URL(string: wodResult.photoUrl!) {
                SDImageCache.shared().removeImage(forKey:s3URL.absoluteString, withCompletion: nil)
            }
            s3Remote.uploadImage(with: url, key: key) { (result) in
                switch result {
                case let .success(s3Path):
                    wodResult.photoUrl = s3Path
                case .failure(_):
                    break
                }
                self.remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
            }
        } else {
            s3Remote.uploadImage(with: url, key: nil) { (result) in
                switch result {
                case let .success(s3Path):
                    wodResult.photoUrl = s3Path
                case .failure(_):
                    break
                }
               self.remote.update(result: wodResult, for: wod.id!, wodType: wod.type!, with: completion)
            }
        }
    }
    
    func delete(wodResult: WODResult, with completion: VoidRequestCompletion?) {
        if wodResult.id == nil {
            completion?(.success())
            return
        }
        
        if wodResult.photoUrl == nil {
            remote.delete(result: wodResult, with: completion)
            return
        }
        
        if let key = wodResult.photoUrl?.components(separatedBy: "/").last {
            s3Remote.deleteImage(with: key, completion: { (_) in
                self.remote.delete(result: wodResult, with: completion)
            })
        }
    }
    
    func getResult(for wod: Workout, with completion: GetResultsRequestCompletion?) {
        remote.getResults(for: wod, with: completion)
    }

}
