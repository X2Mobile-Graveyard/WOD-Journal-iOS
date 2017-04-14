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

    // @Constants
    let defaultWodDetailsSegueIdentifier = "DefaultWodDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWOD = workouts[indexPath.row]
        getResultsAndGoToDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if !UserManager.sharedInstance.isAuthenticated() {
            return []
        }
        
        let wod = workouts[indexPath.row]
        let favoriteAction = createFavoriteCellRowAction(for: wod)
        return [favoriteAction]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == defaultWodDetailsSegueIdentifier {
            let defaultWodDetailsVC = segue.destination as! DefaultWODDetailsViewController
            defaultWodDetailsVC.wod = selectedWOD
        }
    }
    
    // MARK: - Service Calls
    
    func getResultsAndGoToDetails() {
        guard let wod = selectedWOD else {
            return
        }
        
        if !UserManager.sharedInstance.isAuthenticated() {
            self.performSegue(withIdentifier: self.defaultWodDetailsSegueIdentifier, sender: self)
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getResult(for: wod.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(results):
                self.selectedWOD?.results = results
                self.performSegue(withIdentifier: self.defaultWodDetailsSegueIdentifier, sender: self)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
}
