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
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return true
    }

}
