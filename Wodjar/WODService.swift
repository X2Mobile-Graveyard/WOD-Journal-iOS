//
//  WODService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import SDWebImage

struct WODService {
 
    let remote: WODRemoteService
    let s3Remote: S3RemoteService
    
    func update(wodCopy: Workout, with wod: Workout, completion: UpdateWodCompletion?) {
        if let imageUrl = wod.imageUrl {
            if let key = wodCopy.imageUrl?.components(separatedBy: "/").last {
                if imageUrl.isLocalFileUrl() {
                    SDImageCache.shared().deleteOldFiles(completionBlock: nil)
                    s3Remote.uploadImage(with: URL(fileURLWithPath: imageUrl), key: key, completion: { (result) in
                        switch result {
                        case let .success(s3Path):
                            wod.imageUrl = s3Path
                        case .failure(_):
                            break
                        }
                        self.remote.update(wod: wod, with: completion)
                    })
                    
                    return
                }
            } else {
                s3Remote.uploadImage(with: URL(fileURLWithPath: imageUrl), key: nil, completion: { (result) in
                    switch result {
                    case let .success(s3Path):
                        wod.imageUrl = s3Path
                    case .failure(_):
                        break
                    }
                    self.remote.update(wod: wod, with: completion)
                })
            }
            self.remote.update(wod: wod, with: completion)
            return
        }
        
        self.remote.update(wod: wod, with: completion)
    }
    
    func create(customWod: Workout, imagePath: String?, completion: CreateWodCompletion?) {
        guard let wodName = customWod.name else {
            completion?(.failure(NSError.localError(with: "The WOD must have a name.")))
            return
        }
        
        if wodName.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "The WOD must have a name.")))
            return
        }
        
        guard let wodDescription = customWod.wodDescription else {
            completion?(.failure(NSError.localError(with: "The WOD must have a description.")))
            return
        }
        
        if wodDescription.characters.count == 0 {
            completion?(.failure(NSError.localError(with: "The WOD must have a description.")))
            return
        }
        
        if imagePath == nil {
            remote.create(customWod: customWod, with: completion)
            return
        }
        
        let url = URL(fileURLWithPath: imagePath!)
        s3Remote.uploadImage(with: url, key: nil) { (result) in
            switch result {
            case let .success(s3Path):
                customWod.imageUrl = s3Path
            default:
                break
            }
            
            self.remote.create(customWod: customWod, with: completion)
        }
    }
    
    
    func deleteWod(with id: Int?, completion: DeleteWodCompletion?) {
        guard let id = id else {
            completion?(.success())
            return
        }
        
        remote.deleteWod(with: id, completion: completion)
    }
}
