//
//  PersonalRecordRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result
import AWSS3

typealias CreatePersonalRecordCompletion = (Result<Int, NSError>) -> ()
typealias UpdatePersonalRecordCompletion = (Result<Void, NSError>) -> ()
typealias DeletePersonalRecordCompletion = (Result<Void, NSError>) -> ()
typealias UploadImageRequestCompletion = (Result<String, NSError>) -> ()
typealias DeleteImageRequestCompletion = (Result<Void, NSError>) -> ()

protocol PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?)
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?)
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?)
    func uploadImage(with localUrl: URL, key: String?, completion: UploadImageRequestCompletion?)
    func deleteImage(with key: String, completion: DeleteImageRequestCompletion?)
}

class PersonalRecordRemoteServiceTest: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?) {
        completion?(.success())
    }
    
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?) {
        completion?(.success(5))
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        completion?(.success())
    }
    
    func uploadImage(with localUrl: URL, key: String?, completion: UploadImageRequestCompletion?) {
        completion?(.success("asfasf"))
    }
    
    func deleteImage(with key: String, completion: DeleteImageRequestCompletion?) {
        completion?(.success())
    }
}

class PersonalRecordRemoteServiceImpl: PersonalRecordRemoteService {
    func update(personalRecord: PersonalRecord, with completion: UpdatePersonalRecordCompletion?) {
        let request = UpdatePersonalRecordRequest(with: personalRecord)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func create(personalRecord: PersonalRecord, with completion: CreatePersonalRecordCompletion?) {
        let request = CreatePersonalRecordRequest(with: personalRecord)
        
        request.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Error. Please try again.")))
                return
            }
            
            guard let id = response["id"] as? Int else {
                completion?(.failure(NSError.localError(with: "Error. Please try again.")))
                return
            }
            
            completion?(.success(id))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func deletePersonalRecord(with id: Int, completion: DeletePersonalRecordCompletion?) {
        let request = DeletePersonalRecordRequest(with: [id])
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
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
    
    func deleteImage(with key: String, completion: DeleteImageRequestCompletion?) {
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
