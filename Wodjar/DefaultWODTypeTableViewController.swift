//
//  DefaultWODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class DefaultWODTypeTableViewController: WODTypeTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == defaultWodDetailsSegueIdentifier {
            let defaultWodDetailsVC = segue.destination as! DefaultWODDetailsViewController
            defaultWodDetailsVC.wod = selectedWOD
            defaultWodDetailsVC.resultService = WODResultService(remote: WODResultRemoteServiceImpl(), s3Remote: S3RemoteService())
        }
    }
}
