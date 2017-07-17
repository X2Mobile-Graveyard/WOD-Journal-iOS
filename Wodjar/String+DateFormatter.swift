//
//  String+DateFormatter.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import UIKit

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
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func createShareImage() -> UIImage? {
        let textColor = UIColor.white
        let backgroundImage = #imageLiteral(resourceName: "Blackboard")
        var textSize: CGSize
        var textFont: UIFont
        var fontSize: CGFloat = 40
        repeat {
            textFont = UIFont(name: "Chalkduster", size: fontSize)!
            fontSize -= 1
            textSize = self.size(attributes: [NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor])
        }while(backgroundImage.size.width < textSize.width)
        
        let imageSize = CGSize(width: backgroundImage.size.width,
                               height: textSize.height + 50 > 300 ? textSize.height + 50 : 300)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        backgroundImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        
        let heightDiff = imageSize.height - textSize.height
        let widthDiff = imageSize.width - textSize.width
        let pointForText = CGPoint(x: widthDiff / 2, y: heightDiff / 2)
        let rect = CGRect(origin: pointForText, size: textSize)
        self.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
