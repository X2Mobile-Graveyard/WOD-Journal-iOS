//
//  WODTypeDetails.swift
//  Wodjar
//
//  Created by Bogdan Costea on 6/29/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

class WODTypeDetails: NSObject {
    var wodsWorked: Int
    var wodsTotal: Int
    let type: WODType
    
    init(worked: Int, total: Int, type: WODType) {
        wodsTotal = total
        wodsWorked = worked
        self.type = type
    }
    
    init(withDictionary dict: [String: Any]) {
        wodsTotal = dict["capacity"] as? Int ?? 0
        wodsWorked = dict["worked"] as? Int ?? 0
        if let name = dict["name"] as? String {
            type = WODType(rawValue: name.capitalizingFirstLetter()) ?? .custom
        } else {
            type = .custom
        }
    }
    
    func getFormattedString() -> String {
        if !UserManager.sharedInstance.isAuthenticated() {
            if type == .custom {
                return ""
            }
            
            return "\(wodsTotal)"
        }
        
        return "\(wodsWorked)/\(wodsTotal)"
    }
}
