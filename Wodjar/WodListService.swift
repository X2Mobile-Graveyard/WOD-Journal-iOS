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
        
        remote.getResults(for: wodId) { (result) in
            switch result {
            case let .success(wodResults):
                completion?(.success(self.order(wodResults: wodResults)))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
        
//        remote.getResults(for: wodId, with: completion)
    }
    
    func addToFavorite(wodId: Int?, with completion: FavoriteCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        remote.addToFavorite(wodId: wodId, with: completion)
    }
    
    func removeFromFavorite(wodId: Int?, with completion: FavoriteCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        remote.removeFromFavorite(wodId: wodId, with: completion)
    }
    
    func deleteWod(with wodId: Int?, completion: DeleteWodCompletion?) {
        guard let wodId = wodId else {
            completion?(.success())
            return
        }
        
        remote.deleteWod(with: wodId, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func order(wodResults: [WODResult]) -> [WODResult] {
        if wodResults.count < 2 {
            return wodResults
        }
        
        return wodResults.sorted { (result1, result2) -> Bool in
            if result1.updatedAt.compare(result2.updatedAt) == .orderedAscending {
                return false
            }
            
            return true
        }
    }
}
