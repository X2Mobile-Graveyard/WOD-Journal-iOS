//
//  WodListService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

struct WODListService {
    
    let remote: WODListRemoteService
    
    func getWods(with completion: GetWodsRequestCompletion?) {
        remote.getWodsList(with: completion)
    }
    
    func getResult(for wodId: Int?, with completion: GetResultsRequestCompletion?) {
        guard let wodId = wodId else {
            completion?(.success([]))
            return
        }
        
        remote.getResults(for: wodId, with: completion)
    }
}
