//
//  WODDescriptionTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    func populate(with wodDescription: String) {
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        
        let descriptionString = "Description\n\n\(wodDescription)"
        let htmlDesciption = descriptionString.appending("<style>body{font-family: 'System'; font-size:17px;}</style>")
        
        guard let data = htmlDesciption.data(using: .utf8) else {
            textView.text = descriptionString
            return
        }
        
        if let attrString = try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            textView.attributedText = attrString
        } else {
            textView.text = descriptionString
        }
    }

}
