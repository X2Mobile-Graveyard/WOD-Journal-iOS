//
//  WodListService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

struct WODListService {
    
    let listRemote: WODListRemoteService
    let wodRemote: WODRemoteService
    
    func getWods(with completion: GetWodsRequestCompletion?) {
        listRemote.getWodsList(with: completion)
    }
    
    func getResult(for wod: Workout?, with completion: GetResultsRequestCompletion?) {
        guard let wod = wod else {
            completion?(.success([]))
            return
        }
        
        guard wod.id != nil else {
            completion?(.success([]))
            return
        }
        
        listRemote.getResults(for: wod, with: completion)
    }
    
    func addToFavorite(wodId: Int?, with completion: FavoriteCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        wodRemote.addToFavorite(wodId: wodId, with: completion)
    }
    
    func removeFromFavorite(wodId: Int?, with completion: FavoriteCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        wodRemote.removeFromFavorite(wodId: wodId, with: completion)
    }
    
    func deleteWod(with wodId: Int?, completion: DeleteWodCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        wodRemote.deleteWod(with: wodId, completion: completion)
    }
}
