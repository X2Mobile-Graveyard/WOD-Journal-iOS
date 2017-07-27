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
        let wrappedText = wrapText()
        repeat {
            textFont = UIFont(name: "Chalkduster", size: fontSize)!
            fontSize -= 1
            textSize = wrappedText.size(attributes: [NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor])
        }while(backgroundImage.size.width - 40 < textSize.width)
        
        let imageSize = CGSize(width: backgroundImage.size.width - 40,
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
        wrappedText.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func wrapText(for width: Int = 50) -> String {
        if self.characters.count <= width {
            return self
        }
        
        let scanner = Scanner(string: self)
        var sentence: NSString?
        var processedText = ""
        
        while scanner.scanUpToCharacters(from: .newlines, into: &sentence) {
            guard let trimmedSentence = sentence?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            if trimmedSentence.characters.count <= width {
                processedText.append(trimmedSentence + "\n")
                if scanner.scanLocation < self.characters.count - 1 {
                    let index = self.index(self.startIndex, offsetBy: scanner.scanLocation + 1)
                    if self[index] == "\n" {
                        processedText.append("\n")
                    }
                }
                continue
            }
            
            
            var word: NSString?
            let sentenceScanner = Scanner(string: trimmedSentence)
            var lineText = ""
            while sentenceScanner.scanUpToCharacters(from: .whitespaces, into: &word) {
                if let word = word as String! {
                    lineText.append(word)
                    if lineText.characters.count >= width {
                        processedText.append(lineText + "\n")
                        lineText = ""
                    } else {
                        lineText.append(" ")
                    }
                }
            }
            
            if lineText != "" {
                processedText.append(lineText + "\n")
            }
            
            if scanner.scanLocation < self.characters.count - 1 {
                let index = self.index(self.startIndex, offsetBy: scanner.scanLocation + 1)
                if self[index] == "\n" {
                    processedText.append("\n")
                }
            }
        }
        
        return processedText
    }
}
