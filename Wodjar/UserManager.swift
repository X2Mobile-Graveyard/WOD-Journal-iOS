//
//  UserManager.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class UserManager {
    
    var userId: Int?
    var userToken: String?
    var unitType: UnitType?
    
    static let sharedInstance = UserManager()
    
    func isAuthenticated() -> Bool {
        return userId != nil && userToken != nil
    }
}
