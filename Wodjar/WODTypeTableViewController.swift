//
//  WODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class WODTypeTableViewController: UITableViewController {
    
    // @Properties
    var selectedWOD: Workout!
    var viewForHud: UIView {
        return tableView.superview ?? view
    }
    var resultSearchController: UISearchController?
    var filteredWorkouts: [Workout]?
    var canTap = true
    
    // @Injected
    var service: WODListService!
    var wodType: WODType!
    var workouts: [Workout]?
    var dataSource: WodTypesDataSource?
    var wodTypeDelegate: WodTypesDelegate?
    
    // @Constants
    let workoutCellIdentifier = "WorkoutNameCellIdentifier"
    let defaultWodDetailsSegueIdentifier = "DefaultWodDetails"
    let customWodDetailsSegueIdentifier = "CustomWodDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        navigationItem.title = wodType!.rawValue
        tableView.tableFooterView = UIView()
        getWods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Initialization
    
    func initSearchController() {
        self.definesPresentationContext = true
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController?.searchResultsUpdater = self
        resultSearchController?.dimsBackgroundDuringPresentation = false
        resultSearchController?.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController?.searchBar
    }
    
    // MARK: - Service Calls
    
    func getWods() {
        if self.workouts != nil {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getWods(with: wodType) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(wods):
                self.workouts = wods
                self.dataSource?.set(workouts: wods, forType: self.wodType)
                self.tableView.reloadData()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController != nil && resultSearchController!.isActive {
            return filteredWorkouts?.count ?? 0
        }
        return workouts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workoutCellIdentifier, for: indexPath)
        
        if let customCell = cell as? WodListTableViewCell {
            var selectedWorkout: Workout
            if resultSearchController != nil && resultSearchController!.isActive {
                selectedWorkout = filteredWorkouts![indexPath.row]
            } else {
                selectedWorkout = workouts![indexPath.row]
            }
            customCell.populate(with: selectedWorkout)
            return customCell
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !canTap {
            return
        }
        if resultSearchController != nil && resultSearchController!.isActive {
            selectedWOD = filteredWorkouts![indexPath.row]
        } else {
            selectedWOD = workouts![indexPath.row]
        }
        
        showDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Service Calls
    
    func showDetails() {
        guard let wod = selectedWOD else {
            return
        }
        
        if wod.results != nil {
            goToDetailsViewController()
            return
        }
        
        getDetails(for: wod)
    }
    
    func getDetails(for wod: Workout) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        canTap = false
        service.getDetails(for: wod) { (result) in
            self.canTap = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(newWod):
                self.selectedWOD.updateValues(from: newWod)
                self.goToDetailsViewController()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    func goToDetailsViewController() {
        if self.selectedWOD?.type == .custom {
            self.performSegue(withIdentifier: self.customWodDetailsSegueIdentifier, sender: self)
        } else {
            self.performSegue(withIdentifier: self.defaultWodDetailsSegueIdentifier, sender: self)
        }
    }
}

extension WODTypeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredWorkouts?.removeAll(keepingCapacity: false)
        
        guard let textToSearchFor = searchController.searchBar.text else {
            return
        }
        
        filteredWorkouts = workouts?.filter {
            if $0.name == nil {
                return false
            }
            
            let contains = $0.name!.lowercased().contains(textToSearchFor.lowercased())
            
            return contains
        }
        
        tableView.reloadData()
    }
}

extension WODTypeTableViewController: CustomWodUpdateDelegate {
    func didDelete(wod: Workout) {
        workouts?.remove(object: wod)
        self.wodTypeDelegate?.didDelete(wod: wod)
        tableView.reloadData()
    }
}
