//
//  String+DateFormatter.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

extension String {
    func getDateFromWodJournalFormatStyle() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func isLocalFileUrl() -> Bool {
        if self.characters.count == 0 {
            return false
        }
        
        return self.characters.first == "/"
    }
}

extension Date {
    func getWodJournalFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: self)
    }
}
