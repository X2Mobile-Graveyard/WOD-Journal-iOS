//
//  WODRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias UpdateWodCompletion = (Result<Void, NSError>) -> ()
typealias CreateWodCompletion = (Result<Int, NSError>) -> ()
typealias FavoriteCompletion = (Result<Void, NSError>) -> ()
typealias DeleteWodCompletion = (Result<Void, NSError>) -> ()

protocol WODRemoteService {
    func update(wod: Workout, with: UpdateWodCompletion?)
    func create(customWod: Workout, with: CreateWodCompletion?)
    func addToFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?)
    func removeFromFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?)
    func deleteWod(with wodId: Int, completion: DeleteWodCompletion?)
}

class WODRemoteServiceTest: WODRemoteService {
    func update(wod: Workout, with completion: UpdateWodCompletion?) {
        completion?(.success())
    }
    
    func create(customWod: Workout, with completion: CreateWodCompletion?) {
        completion?(.success(40))
    }
    
    func addToFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?) {
        completion?(.success())
    }
    
    func removeFromFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?) {
        completion?(.success())
    }
    
    func deleteWod(with wodId: Int, completion: DeleteWodCompletion?) {
        completion?(.success())
    }
}

class WODRemoteServiceImpl: WODRemoteService {
    func create(customWod: Workout, with completion: CreateWodCompletion?) {
        let request = CreateWODRequest(with: customWod)
        
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
    
    func update(wod: Workout, with completion: UpdateWodCompletion?) {
        let request = UpdateWodRequest(with: wod)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func addToFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?) {
        let request = AddToFavoriteRequest(wodId: wodId, isDefault: isDefault)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func removeFromFavorite(wodId: Int, isDefault: Bool, with completion: FavoriteCompletion?) {
        let request = RemoveFavoriteRequest(wodId: wodId, isDefault: isDefault)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    func deleteWod(with wodId: Int, completion: DeleteWodCompletion?) {
        let request = DeleteWODRequest(wodId: wodId)
        
        request.success = { _, _ in
            completion?(.success())
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
}
