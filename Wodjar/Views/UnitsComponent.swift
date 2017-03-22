//
//  UnitsComponent.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class UnitsComponent: IBControl {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var index: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = index
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func unitTypeChanged(_ sender: UISegmentedControl) {
        index = sender.selectedSegmentIndex
        sendActions(for: .valueChanged)
    }
    
}
