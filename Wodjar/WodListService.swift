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
    
    func getWods(with type: WODType, with completion: GetWodsRequestCompletion?) {
        listRemote.getWodsList(with: type, completion: completion)
    }
    
    func getWodsTypes(with completion: GetWodsTypesCompletion?) {
        listRemote.getWodsTypes(with: completion)
    }
    
    func getDetails(for wod: Workout, with completion: GetWodDetailsCompletion?) {
        listRemote.getDetails(for: wod, with: completion)
    }
    
    func deleteWod(with wodId: Int?, completion: VoidRequestCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        wodRemote.deleteWod(with: wodId, completion: completion)
    }
}
