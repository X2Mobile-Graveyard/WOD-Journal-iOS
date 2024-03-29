//
//  WODTypesTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODTypesTableViewController: UITableViewController {
    
    // @Injected
    var workouts: WorkoutList!
    
    // @Properties
    var resultSearchController = UISearchController()
    var filteredWorkouts = WorkoutList()
    
    // @Constants
    let wodTypeCellIdentifier = "WodTypeTableViewCellIdentifier"
    let wodResultCellIdentifier = "WodResultTableViewCellIdentifier"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
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
                return 2
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !resultSearchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: wodTypeCellIdentifier, for: indexPath) as! WODTypeTableViewCell
            
            switch indexPath.section {
            case 0:
                let wodType = workouts.wodTypesOrder[indexPath.row]
                let totalWoods = workouts.totalWods(for: wodType)
                let completed = workouts.completedWods(for: wodType)
                cell.populate(with: wodType, completedWods: completed, totalWods: totalWoods)
            case 1:
                if indexPath.row == 0 {
                    cell.populateFavorites(with: workouts.favorites.count)
                } else {
                    let completed = workouts.completedWods(for: .custom)
                    cell.populate(with: .custom, completedWods: completed, totalWods: workouts.customs.count)
                }
            default:
                break
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: wodResultCellIdentifier, for: indexPath) as! PresonalRecordsListTableViewCell
        let sectionType = filteredWorkouts.filteredSections()[indexPath.section]
        let workout = filteredWorkouts.workout(with: sectionType, at: indexPath.row)
        
        cell.populate(with: workout.name, present: workout.isCompleted)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if resultSearchController.isActive {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        view.backgroundColor = tableView.backgroundColor
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !resultSearchController.isActive {
            if section == 1 {
                return 50
            } else {
                return 0
            }
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.isActive {
            let type = filteredWorkouts.filteredSections()[section]
            return type.rawValue
        }
        
        return nil
    }
    
}

extension WODTypesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredWorkouts = WorkoutList()
        
        guard let textToSearchFor = searchController.searchBar.text  else {
            return
        }
        
        filteredWorkouts.workouts = workouts.workouts.filter {
            return $0.name.lowercased().contains(textToSearchFor.lowercased())
        }
        
        tableView.reloadData()
    }
}
