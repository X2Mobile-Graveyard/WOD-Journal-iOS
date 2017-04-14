//
//  Array+RemoveByValue.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/13/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
