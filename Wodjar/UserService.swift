//
//  UserService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/19/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import SDWebImage

struct UserService {
    let s3RemoteService: S3RemoteService
    let remoteService: UserRemoteService
    
    func updateUser(with newName: String?, imageUrl: String?, completion: VoidRequestCompletion?) {
        if (newName == nil || newName!.characters.count == 0) &&
            (UserManager.sharedInstance.userName != nil && (UserManager.sharedInstance.userName?.characters.count)! > 0) {
            completion?(.failure(NSError.localError(with: "Please enter your name")))
            return
        }
        
        let name = newName
        
        guard let imageUrl = imageUrl else {
            if UserManager.sharedInstance.imageUrl == nil {
                if name == nil {
                    completion?(.success())
                    return
                }
                remoteService.updateUser(with: name, pictureUrl: nil, completion: completion)
                return
            }
            
            if let key = UserManager.sharedInstance.imageUrl?.components(separatedBy: "/").last {
                s3RemoteService.deleteImage(with: key, completion: { (result) in
                    UserManager.sharedInstance.imageUrl = nil
                    self.remoteService.updateUser(with: name, pictureUrl: "", completion: completion)
                })
            }
            
            return
        }
        
        if !imageUrl.contains("example") {
            if name == nil {
                completion?(.success())
                return
            }
            remoteService.updateUser(with: name, pictureUrl: nil, completion: completion)
            return
        }
        
        let url = URL(fileURLWithPath: imageUrl)
        
        if let key = UserManager.sharedInstance.imageUrl?.components(separatedBy: "/").last {
            SDImageCache.shared().removeImage(forKey: UserManager.sharedInstance.imageUrl!, withCompletion: nil)
            s3RemoteService.uploadImage(with: url, key: key) { (result) in
                switch result {
                case let .success(s3Path):
                    UserManager.sharedInstance.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.updateUser(with: name, pictureUrl: UserManager.sharedInstance.imageUrl, completion: completion)
            }
        } else {
            s3RemoteService.uploadImage(with: url, key: UserManager.sharedInstance.email) { (result) in
                switch result {
                case let .success(s3Path):
                    UserManager.sharedInstance.imageUrl = s3Path
                case .failure(_):
                    break
                }
                self.remoteService.updateUser(with: name, pictureUrl: UserManager.sharedInstance.imageUrl, completion: completion)
            }
        }
    }
}
