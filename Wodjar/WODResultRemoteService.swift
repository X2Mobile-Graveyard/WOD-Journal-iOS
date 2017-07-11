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
typealias GetResultsRequestCompletion = (Result<[WODResult], NSError>) -> ()

protocol WODResultRemoteService {
    func add(result: WODResult, for: Int, wodType:WODType, with completion: CreateResultCompletion?)
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: VoidRequestCompletion?)
    func delete(result: WODResult, with completion: VoidRequestCompletion?)
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?)
}

class WODResultRemoteServiceTest: WODResultRemoteService {
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: VoidRequestCompletion?) {
        completion?(.success())
    }

    func add(result: WODResult, for: Int, wodType: WODType, with completion: CreateResultCompletion?) {
        completion?(.success(30))
    }
    
    func delete(result: WODResult, with completion: VoidRequestCompletion?) {
        completion?(.success())
    }
    
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?) {
        
    }
}

class WODResultRemoteServiceImpl: WODResultRemoteService {
    
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.success([WODResult]()))
            return
        }
        let request = GetWodResultRequest(with: wod.id!)
        
        request.success = { _, result in
            guard let resultDict = result as? [String: Any] else {
                completion?(.success([]))
                return
            }
            
            guard let resultsArray = resultDict["wod_results"] as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            var results = [WODResult]()
            for resultDict in resultsArray {
                let wodResult = WODResult(from: resultDict, with: wod.category)
                results.append(wodResult)
            }
            
            completion?(.success(results))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }

    
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
    
    func update(result: WODResult, for wodId: Int, wodType: WODType, with completion: VoidRequestCompletion?) {
        let request = UpdateWODResultRequest(with: result.createUpdateDict(with: wodId, wodType: wodType))
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest();
    }
    
    func delete(result: WODResult, with completion: VoidRequestCompletion?) {
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
