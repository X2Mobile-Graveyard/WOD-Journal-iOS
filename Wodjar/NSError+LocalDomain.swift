//
//  NSError+LocalDomain.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/23/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

extension NSError {
    class func localError(with message: String) -> NSError {
        return NSError(domain: "local.domain", code: 101, userInfo: ["error": message])
    }
}
