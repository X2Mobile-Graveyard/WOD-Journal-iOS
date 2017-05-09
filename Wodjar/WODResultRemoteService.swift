//
//  WODResultRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias CreateResultCompletion = (Result<Int, NSError>) -> ()
typealias UpdateResultCompletion = (Result<Void, NSError>) -> ()
typealias DeleteResultCompletion = (Result<Void, NSError>) -> ()

protocol WODResultRemoteService {
    func add(result: WODResult, for: Int, wodType:WODType, with completion: CreateResultCompletion?)
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: UpdateResultCompletion?)
    func delete(result: WODResult, with completion: DeleteResultCompletion?)
}

class WODResultRemoteServiceTest: WODResultRemoteService {
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: UpdateResultCompletion?) {
        completion?(.success())
    }

    func add(result: WODResult, for: Int, wodType: WODType, with completion: CreateResultCompletion?) {
        completion?(.success(30))
    }
    
    func delete(result: WODResult, with completion: DeleteResultCompletion?) {
        completion?(.success())
    }
}

class WODResultRemoteServiceImpl: WODResultRemoteService {
    func add(result: WODResult, for wodId: Int, wodType: WODType, with completion: CreateResultCompletion?) {
        let request = CreateWODResultRequest(with: result.createUpdateDict(with: wodId, wodType: wodType))
        
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
    
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: UpdateResultCompletion?) {
        let request = UpdateWODResultRequest(with: result.createUpdateDict(with: wodId, wodType: wodType))
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest();
    }
    
    func delete(result: WODResult, with completion: DeleteResultCompletion?) {
        let request = DeleteWODResultRequest(resultId: result.id!)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
