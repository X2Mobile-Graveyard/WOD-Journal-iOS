//
//  WODHistoryViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODHistoryViewController: UIViewController {
    
    @IBOutlet var historyTextView: UITextView!
    
    var historyText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.text = historyText
        historyTextView.layer.cornerRadius = 5
        navigationItem.title = "History"
    }
    
}
