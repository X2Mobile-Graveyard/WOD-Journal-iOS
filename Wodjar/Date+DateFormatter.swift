//
//  Date+DateFormatter.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation

extension Date {
    func getDateAsWodJournalString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}