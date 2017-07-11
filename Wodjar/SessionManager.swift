//
//  SessionManager.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class SessionManager {
    
    var apiKey = "zz&Ci9XK7Wm8WrWXdT^jAiAmS4OT9mMNDB101Sye*rbrGUPUxj*Q1Hpk@I1i%t7F"
    var serverBase: String = "https://wodjar-production.herokuapp.com/api/v1/"
        
    static let sharedInstance = SessionManager()
    
    func deleteAllUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
}
