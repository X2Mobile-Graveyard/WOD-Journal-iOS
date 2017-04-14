//
//  UIViewController+Toolbar.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/13/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension UIViewController {
    func createKeyboardToolbar(with hiddingOtion: String, selector: Selector?) -> UIToolbar {
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardItem = UIBarButtonItem(title: hiddingOtion,
                                               style: .plain,
                                               target: self,
                                               action: selector)
        toolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    func createKeyboardToolbar(cancelButton: String, with cancelSelector: Selector, doneButton:String?, doneSelector: Selector?) -> UIToolbar {
        let toolbar = createKeyboardToolbar(with: cancelButton, selector: cancelSelector)
        
        if doneButton == nil && doneSelector == nil {
            return toolbar
        }
        
        var doneTitle: String = "Done"
        if doneButton != nil {
            doneTitle = doneButton!
        }
        
        let doneKeyboardItem = UIBarButtonItem(title: doneTitle,
                                               style: .done,
                                               target: self,
                                               action: doneSelector)
        toolbar.items?.append(doneKeyboardItem)
        toolbar.sizeToFit()
        
        return toolbar
    }
}
