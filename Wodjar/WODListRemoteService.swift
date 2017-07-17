//
//  WODListRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias GetWodsRequestCompletion = (Result<[Workout], NSError>) -> ()
typealias GetWodsTypesCompletion = (Result<[WODTypeDetails], NSError>) -> ()
typealias GetWodDetailsCompletion = (Result<Workout, NSError>) -> ()


protocol WODListRemoteService {
    func getWodsList(with type: WODType, completion: GetWodsRequestCompletion?)
    func getWodsTypes(with completion: GetWodsTypesCompletion?)
    func getDetails(for wod: Workout, with completion: GetWodDetailsCompletion?)
}

class WODListRemoteServiceTest: WODListRemoteService {
    
    func getDetails(for wod: Workout, with completion: GetWodDetailsCompletion?) {
        
    }
    
    func getWodsTypes(with completion: GetWodsTypesCompletion?) {
        
    }
    
    func getWodsList(with type: WODType, completion: GetWodsRequestCompletion?) {
        
    }
}

class WODListRemoteServiceImpl: WODListRemoteService {
    
    func getDetails(for wod: Workout, with completion: GetWodDetailsCompletion?) {
        if UserManager.sharedInstance.isAuthenticated() {
            getUserWodDetails(with: wod, completion: completion)
            return
        }
        
        getDefaultWodDetails(with: wod, completion: completion)
    }
    
    func getWodsTypes(with completion: GetWodsTypesCompletion?) {
        if UserManager.sharedInstance.isAuthenticated() {
            getUserWodTypes(with: completion)
            return;
        }
        
        getDefaultWodTypes(with: completion)
    }
    
    func getWodsList(with type: WODType, completion: GetWodsRequestCompletion?) {
        if UserManager.sharedInstance.isAuthenticated() {
            getUserWods(with: type, completion: completion)
            return
        }
        
        getDefaultWods(with: type, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func getUserWodDetails(with wod: Workout, completion: GetWodDetailsCompletion?) {
        if wod.type! == .custom {
            getCustomUserWodsDetails(with: wod, completion: completion)
            return
        }
        
        getDefaultUserWodsDetails(with: wod, completion: completion)
    }
    
    private func getDefaultUserWodsDetails(with wod: Workout, completion: GetWodDetailsCompletion?) {
        let request = GetWodDetailsRequest(with: wod.id!, wodType: wod.type!)
        
        request.success = { _, result in
            guard let resultDict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Something wrong happened.")))
                return
            }
            
            let newWorkout = Workout(from: resultDict)
            completion?(.success(newWorkout))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getCustomUserWodsDetails(with wod: Workout, completion: GetWodDetailsCompletion?) {
        let request = GetCustomWodDetailsRequest(with: wod.id!)
        
        request.success = { _, result in
            guard let resultDict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Something wrong happened.")))
                return
            }
            
            let newWorkout = Workout(from: resultDict)
            completion?(.success(newWorkout))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()

    }
    
    private func getDefaultWodDetails(with wod: Workout, completion: GetWodDetailsCompletion?) {
        let request = GetDefaultWodDetails(with: wod.id!, wodType: wod.type!)
        
        request.success = { _, result in
            guard let resultDict = result as? [String: Any] else {
                completion?(.failure(NSError.localError(with: "Something wrong happened.")))
                return
            }
            
            let newWorkout = Workout(from: resultDict)
            completion?(.success(newWorkout))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getDefaultWodTypes(with completion: GetWodsTypesCompletion?) {
        let request = GetDefaultWodCategories()
        
        request.success = { _, result in
            guard let resultArray = result as? [[String: Any]] else {
                completion?(.failure(NSError.localError(with: "Something wrong happened")))
                return;
            }
            
            var allTypes = [WODTypeDetails]()
            for categoryDict in resultArray {
                let newWodDetail = WODTypeDetails(withDictionary: categoryDict)
                allTypes.append(newWodDetail)
            }
            
            completion?(.success(allTypes))
            
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getUserWodTypes(with completion: GetWodsTypesCompletion?) {
        let request = GetWodCategories()
        
        request.success = { _, result in
            guard let resultArray = result as? [[String: Any]] else {
                completion?(.failure(NSError.localError(with: "Something wrong happened")))
                return;
            }
            
            var allTypes = [WODTypeDetails]()
            for categoryDict in resultArray {
                let newWodDetail = WODTypeDetails(withDictionary: categoryDict)
                allTypes.append(newWodDetail)
            }
            
            completion?(.success(allTypes))
            
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
        
    }
    
    private func getUserWods(with type: WODType, completion: GetWodsRequestCompletion?) {
        if type == .custom {
            getUserCustomWods(with: completion)
            return
        }
        
        getUserDefaultWods(with: type, completion: completion)
    }
    
    private func getUserCustomWods(with completion: GetWodsRequestCompletion?) {
        let request = GetCustomWodsRequest()
        
        request.success = { _, response in
            guard let wods = response as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            let workouts = self.createWorkoutArray(from: wods)
            
            completion?(.success(self.orderByDate(wods: workouts)))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getUserDefaultWods(with type: WODType, completion: GetWodsRequestCompletion?) {
        let request = GetWodsRequest(with: type)
        
        request.success = { request, recvResponse in
            guard let wods = recvResponse as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            let workouts = self.createWorkoutArray(from: wods)
            
            completion?(.success(type != .custom ? self.orderAlphabetically(wods: workouts) : workouts))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getDefaultWods(with type: WODType, completion: GetWodsRequestCompletion?) {
        let request = GetDefaultWodsRequest(with: type)
        
        request.success = { _, response in
            guard let defaultWods = response as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            let workouts = self.createWorkoutArray(from: defaultWods)
            
            completion?(.success(self.orderAlphabetically(wods: workouts)))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func createWorkoutArray(from wodsArray: [[String: Any]]) -> [Workout] {
        var workouts = [Workout]()
        for wodDict in wodsArray {
            let newWorkout = Workout(from: wodDict)
            workouts.append(newWorkout)
        }
        
        return workouts
    }
    
    private func orderAlphabetically(wods: [Workout]) -> [Workout] {
        return wods.sorted(by: { (wod1, wod2) -> Bool in
            return (wod1.name?.compare(wod2.name!) == .orderedAscending)
        })
    }
    
    private func orderByDate(wods: [Workout]) -> [Workout] {
        return wods.sorted(by: { (wod1, wod2) -> Bool in
            return wod1.date!.compare(wod2.date!) == .orderedDescending
        })
    }
}
