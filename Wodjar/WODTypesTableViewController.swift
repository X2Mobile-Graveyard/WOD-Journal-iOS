//
//  WODTypesTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol WODTypeDelegate {
    func didDelete(wod: Workout)
    func didAdd(wod: Workout)
}

class WODTypesTableViewController: UITableViewController {
    
    // @Injected
    var service: WODListService!
    
    // @Properties
    var resultSearchController: UISearchController!
    var filteredWorkouts = WorkoutList()
    var selectedWorkouts = [Workout]()
    var selectedWorkout: Workout?
    var favoritesSelected = false
    var workouts = WorkoutList()
    
    // @Constants
    let wodTypeCellIdentifier = "WodTypeTableViewCellIdentifier"
    let wodResultCellIdentifier = "WodResultTableViewCellIdentifier"
    let customWodsTableIdentifier = "CustomWodTypeViewControllerIdentifier"
    let defaultWodsTableIdentifier = "DefaultWodTypeViewControllerIdentifier"
    let defaultDetailsSegueIdetifier = "goToDefaultWodsIdentifier"
    let customDetailsSegueIdentifier = "goToCustomWodsIdentifier"
    let headerHeight: CGFloat = 20
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        getWods()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: NSNotification.Name(rawValue: "Auth"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UI Initalization
    
    func setupSearchController() {
        definesPresentationContext = true
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        
        navigationItem.titleView = resultSearchController.searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if resultSearchController.isActive {
            return filteredWorkouts.filteredSections().count
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            let sectionType = filteredWorkouts.filteredSections()[section]
            return filteredWorkouts.totalWods(for: sectionType)
        } else {
            if section == 0 {
                return 4
            } else {
                return 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resultSearchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: wodResultCellIdentifier, for: indexPath) as! PresonalRecordsListTableViewCell
            let sectionType = filteredWorkouts.filteredSections()[indexPath.section]
            let workout = filteredWorkouts.workout(with: sectionType, at: indexPath.row)
            
            cell.populate(with: workout.name!, bestRecord: workout.bestResult)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: wodTypeCellIdentifier, for: indexPath) as! WODTypeTableViewCell
        
        switch indexPath.section {
        case 0:
            let wodType = workouts.wodTypesOrder[indexPath.row]
            let totalWoods = workouts.totalWods(for: wodType)
            let completed = workouts.completedWods(for: wodType)
            cell.populate(with: wodType, completedWods: completed, totalWods: totalWoods)
        case 1:
            if indexPath.row == 0 {
                let completed = workouts.completedWods(for: .custom)
                cell.populate(with: .custom, completedWods: completed, totalWods: workouts.customs.count)
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if resultSearchController.isActive {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: headerHeight))
        view.backgroundColor = tableView.backgroundColor
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !resultSearchController.isActive {
            if section == 1 {
                return headerHeight
            } else {
                return 0.1
            }
        }
    
        if section == 0 {
            return headerHeight + 20
        }
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.isActive {
            let type = filteredWorkouts.filteredSections()[section]
            return type.rawValue
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultSearchController.isActive {
            let sectionType = filteredWorkouts.filteredSections()[indexPath.section]
            selectedWorkout = filteredWorkouts.workout(with: sectionType, at: indexPath.row)
            
            if sectionType == .custom {
                getResultsAndGoToDetails(with: customDetailsSegueIdentifier)
            } else {
                getResultsAndGoToDetails(with: defaultDetailsSegueIdetifier)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            return
        }
        
        favoritesSelected = false
        
        var isCustom = false
        switch indexPath.section {
        case 0:
            let wodType = workouts.wodTypesOrder[indexPath.row]
            selectedWorkouts = workouts.getWorkouts(for: wodType)
        case 1:
            if !UserManager.sharedInstance.isAuthenticated() {
                tableView.deselectRow(at: indexPath, animated: true)
                presentLoginScreen(with: {
                    self.getWods()
                })
                return
            }
            
            if indexPath.row == 0 {
                selectedWorkouts = workouts.getWorkouts(for: .custom)
                isCustom = true
            }
        default:
            break
        }
        
        if isCustom {
            performSegue(withIdentifier: customWodsTableIdentifier, sender: self)
        } else {
            performSegue(withIdentifier: defaultWodsTableIdentifier, sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case customWodsTableIdentifier:
            let customVC = segue.destination as! CustomWODTypeTableViewController
            customVC.workouts = selectedWorkouts
            customVC.isFavorite = favoritesSelected
            customVC.service = service
            customVC.delegate = self
        case defaultWodsTableIdentifier:
            let defaultVC = segue.destination as! DefaultWODTypeTableViewController
            defaultVC.workouts = selectedWorkouts
            defaultVC.isFavorite = favoritesSelected
            defaultVC.service = service
        case customDetailsSegueIdentifier:
            let customWodDetailViewController = segue.destination as! CustomWODDetailsViewController
            customWodDetailViewController.wod = selectedWorkout!
            customWodDetailViewController.service = WODService(remote: WODRemoteServiceImpl(), s3Remote: S3RemoteService())
            customWodDetailViewController.resultService = WODResultService(remote: WODResultRemoteServiceImpl(), s3Remote: S3RemoteService())
        case defaultDetailsSegueIdetifier:
            let defaultWodDetaiViewController = segue.destination as! DefaultWODDetailsViewController
            defaultWodDetaiViewController.wod = selectedWorkout!
            defaultWodDetaiViewController.resultService = WODResultService(remote: WODResultRemoteServiceImpl(), s3Remote: S3RemoteService())
        default:
            break
        }
    }
    
    // MARK: - Service Calls
    
    func getWods() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getWods { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(wodsList):
                self.workouts = wodsList
                self.tableView.reloadData()
            case .failure(_):
                self.handleError(result: result)
                self.workouts = WorkoutList()
            }
        }
    }
    
    func getResultsAndGoToDetails(with segueIdentifier: String) {
        guard let workout = selectedWorkout else {
            return
        }
        
        if !UserManager.sharedInstance.isAuthenticated() {
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getResult(for: workout) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(results):
                self.selectedWorkout?.results = results
                self.performSegue(withIdentifier: segueIdentifier, sender: self)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    // MARK: - Login Notification
    
    func didLogin() {
        getWods()
    }
}

extension WODTypesTableViewController: WODTypeDelegate {
    func didDelete(wod: Workout) {
        workouts.workouts.remove(object: wod)
    }
    
    func didAdd(wod: Workout) {
        workouts.workouts.append(wod)
    }
}

extension WODTypesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredWorkouts = WorkoutList()
        
        guard let textToSearchFor = searchController.searchBar.text  else {
            return
        }
        
        filteredWorkouts.workouts = workouts.workouts.filter {
            return $0.name!.lowercased().contains(textToSearchFor.lowercased())
        }
        
        tableView.reloadData()
    }
}
