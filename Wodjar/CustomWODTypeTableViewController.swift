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
    let createWodViewControllerSegueIdentifier = "CreateCustomWODSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initSearchController() {
        
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Delete") { (acton, indexPath) in
            self.deleteWod(at: indexPath.row)
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workoutCellIdentifier, for: indexPath)
        
        if let customCell = cell as? CustomWodTypeTableViewCell {
            var selectedWorkout: Workout
            selectedWorkout = workouts![indexPath.row]
            customCell.populate(with: selectedWorkout)
            return customCell
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == customWodDetailsSegueIdentifier {
            let customWodDetailsVC = segue.destination as! CustomWODDetailsViewController
            customWodDetailsVC.wod = selectedWOD
            customWodDetailsVC.service = WODService(remote: service.wodRemote, s3Remote: S3RemoteService())
            customWodDetailsVC.resultService = WODResultService(remote: WODResultRemoteServiceImpl(), s3Remote: S3RemoteService())
            customWodDetailsVC.delegate = self
        } else if identifier == createWodViewControllerSegueIdentifier {
            let createWodViewController = segue.destination as! CreateCustomWODViewController
            createWodViewController.customWod = Workout()
            createWodViewController.service = WODService(remote: service.wodRemote, s3Remote: S3RemoteService())
            createWodViewController.delegate = self
        }
    }
    
    // MARK: - Service Calls
    
    func deleteWod(at index: Int) {
        guard let wod = workouts?[index] else {
            return
        }
        
        MBProgressHUD.showAdded(to: viewForHud, animated: true)
        service.deleteWod(with: wod.id) { (result) in
            MBProgressHUD.hide(for: self.viewForHud, animated: true)
            switch result {
            case .success():
                self.workouts?.remove(at: index)
                self.wodTypeDelegate?.didDelete(wod: wod)
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
        workouts?.append(customWod)
        tableView.reloadData()
        wodTypeDelegate?.didCreate(wod: customWod)
    }
}
