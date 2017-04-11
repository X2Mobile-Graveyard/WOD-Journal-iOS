//
//  DateTextField.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/8/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DateTextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        
        return CGRect.init(origin: CGPoint(x: 0, y: 0) , size: CGSize(width:0.1, height:0.1))
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return true
    }

}
