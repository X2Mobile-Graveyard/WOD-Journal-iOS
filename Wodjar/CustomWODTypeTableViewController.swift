//
//  CustomWODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class CustomWODTypeTableViewController: WODTypeTableViewController {

    // @Constants
    let customWodDetailsSegueIdentifier = "CustomWodDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWOD = workouts[indexPath.row]
        getResultsAndGoToDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == customWodDetailsSegueIdentifier {
            let customWodDetailsVC = segue.destination as! CustomWODDetailsViewController
            customWodDetailsVC.wod = selectedWOD
        }
    }
    
    // MARK: - Service Calls
    
    func getResultsAndGoToDetails() {
        guard let wod = selectedWOD else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getResult(for: wod.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(results):
                self.selectedWOD?.results = results
                self.performSegue(withIdentifier: self.customWodDetailsSegueIdentifier, sender: self)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
}
