//
//  WodJurnalNavigationController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/13/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WodJurnalNavigationController: UINavigationController {

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
