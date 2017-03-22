//
//  MoreViewController.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapUnitsComponent(_ sender: Any) {
        let index = (sender as! UnitsComponent).index
        
        print(index)
    }
    
    @IBAction func didTapMoreComponent(_ sender: UIView) {
        switch sender.tag {
        case 1:
            print("feedback")
        case 2:
            print("premium subscription")
        case 3:
            print("restore purchases")
        default:
            break
        }
    }
}
