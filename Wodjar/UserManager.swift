//
//  UserManager.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class UserManager {
    let userIdKey = "WODJournalUserdId"
    let userTokenKey = "WODJournalUserToken"
    let unitSystemKey = "WODJournalUnitSystem"
    let userNameKey = "WODJournalUserName"
    let userImageKey = "WODJournalUserImageKey"
    let userEmailKey = "WODJournalUserEmail"
    
    var userId: Int? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userIdKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userIdKey)
            }
        }
        
        get {
            return UserDefaults.standard.object(forKey: userIdKey) as! Int?
        }
    }
    var userToken: String? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userTokenKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userTokenKey)
            }
        }
        
        get {
            return UserDefaults.standard.object(forKey: userTokenKey) as! String?
        }
    }
    var unitType: UnitType {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: unitSystemKey)
        }
        
        get {
            if let type = UserDefaults.standard.object(forKey: unitSystemKey) as? Int {
                return UnitType(rawValue: type)!
            }
            
            if Locale.current.usesMetricSystem {
                return .metric
            } else {
                return .imperial
            }
        }
    }
    var hasMonthlySubscription: Bool = false
    var hasYearSubscription: Bool = false
    var hasPremiumSubscription: Bool {
        return hasMonthlySubscription || hasYearSubscription
    }
    var userName: String? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userNameKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userNameKey)
            }
        }
        
        get {
            return UserDefaults.standard.object(forKey: userNameKey) as? String
        }
    }
    var imageUrl: String? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userImageKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userImageKey)
            }
        }
        
        get {
            return UserDefaults.standard.object(forKey: userImageKey) as? String
        }
    }
    var email: String? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: userEmailKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: userEmailKey)
            }
        }
        
        get {
            return UserDefaults.standard.object(forKey: userEmailKey) as? String
        }
    }
    
    static let sharedInstance = UserManager()
    
    func isAuthenticated() -> Bool {
        return userId != nil && userToken != nil
    }
    
    func signOut() {
        userId = nil
        userToken = nil
        UserDefaults.standard.removeObject(forKey: unitSystemKey)
        userName = nil
        imageUrl = nil
        SessionManager.sharedInstance.deleteAllUserDefaults()
    }
}
