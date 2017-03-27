//
//  IBView.swift
//  Wodjar
//
//  Created by Mihai Erős on 21/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

@IBDesignable class IBControl: UIControl {

    var nibSize: CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(reflecting: type(of: self)).components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        let subView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.nibSize = subView.frame.size
        self.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        let bindings = ["view": subView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: bindings))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: nibSize.height)
    }
}
