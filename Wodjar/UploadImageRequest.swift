//
//  UploadImageRequest.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/24/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import AWSS3

class UploadImageRequest {
    
    init() {

    }
    
    func uploadFile(imageUrl: URL) {
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "workoutoftheday-images"
        uploadRequest?.body = imageUrl
        uploadRequest?.key = "testImage.jpg"
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                }
                return nil
            }
            
            let uploadOutput = task.result
            print("Upload complete for: \(uploadRequest?.key)")
            return nil
        })
    }

}
