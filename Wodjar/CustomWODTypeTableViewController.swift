//
//  CustomWODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol CustomWodDelegate {
    func didCreate(customWod: Workout)
}

class CustomWODTypeTableViewController: WODTypeTableViewController {

    // @Constants
    let customWodDetailsSegueIdentifier = "CustomWodDetails"
    let createWodViewControllerSegueIdentifier = "CreateCustomWODSegueIdentifier"
    
    // @Injected
    var delegate: WODTypeDelegate?
    
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
        let wod = workouts[indexPath.row]
        let favoriteAction = createFavoriteCellRowAction(for: wod)
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Delete") { (acton, indexPath) in
            self.deleteWod(at: indexPath.row)
        }
        
        return [deleteAction, favoriteAction]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == customWodDetailsSegueIdentifier {
            let customWodDetailsVC = segue.destination as! CustomWODDetailsViewController
            customWodDetailsVC.wod = selectedWOD
            customWodDetailsVC.service = WODService(remote: WODRemoteServiceTest(), s3Remote: S3RemoteService())
        } else if identifier == createWodViewControllerSegueIdentifier {
            let createWodViewController = segue.destination as! CreateCustomWODViewController
            createWodViewController.customWod = Workout()
            createWodViewController.service = WODService(remote: WODRemoteServiceTest(), s3Remote: S3RemoteService())
            createWodViewController.delegate = self
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
    
    func deleteWod(at index: Int) {
        let wod = workouts[index]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deleteWod(with: wod.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success():
                self.workouts.remove(at: index)
                self.delegate?.didDelete(wod: wod)
                self.tableView.reloadData()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
}

extension CustomWODTypeTableViewController: CustomWodDelegate {
    func didCreate(customWod: Workout) {
        customWod.type = .custom
        workouts.append(customWod)
        tableView.reloadData()
        delegate?.didAdd(wod: customWod)
    }
}
