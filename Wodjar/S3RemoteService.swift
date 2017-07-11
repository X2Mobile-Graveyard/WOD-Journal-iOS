//
//  S3RemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import AWSS3

class S3RemoteService {
    func uploadImage(with imageUrl: URL, key: String?, completion: UploadImageRequestCompletion?) {
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "workoutoftheday-images"
        uploadRequest?.body = imageUrl
        if key == nil {
            let timestamp = UInt64(floor(Date().timeIntervalSince1970 * 1000))
            uploadRequest?.key = "\(UserManager.sharedInstance.userId!)_\(timestamp).jpg"
        } else {
            uploadRequest?.key = key!
        }
        
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        completion?(.failure(NSError.localError(with: "Could not upload picture")))
                    }
                } else {
                    completion?(.failure(NSError.localError(with: "Could not upload picture")))
                }
                return nil
            }
            
            if let uploadRequest = uploadRequest {
                completion?(.success("https://s3.eu-west-2.amazonaws.com/workoutoftheday-images/\(uploadRequest.key!)"))
            } else {
                completion?(.failure(NSError.localError(with: "Could not upload picture.")))
            }
            
            return nil
        })
    }
    
    func deleteImage(with key: String, completion: VoidRequestCompletion?) {
        let s3 = AWSS3.default()
        let deleteObjectRequest = AWSS3DeleteObjectRequest()
        deleteObjectRequest?.bucket = "workoutoftheday-images"
        deleteObjectRequest?.key = key
        
        s3.deleteObject(deleteObjectRequest!).continueWith { (task:AWSTask) -> AnyObject? in
            if let _ = task.error {
                completion?(.failure(NSError.localError(with: "Could not delete picture")))
                return nil
            }
            completion?(.success())
            return nil
        }
    }
}
