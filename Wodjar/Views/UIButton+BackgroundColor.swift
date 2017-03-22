//
//  UIButton+BackgroundColor.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.frame.height))
        
        let currentContext = UIGraphicsGetCurrentContext()!
        currentContext.setFillColor(color.cgColor)
        currentContext.fill(CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
