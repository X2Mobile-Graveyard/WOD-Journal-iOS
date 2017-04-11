//
//  WODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODTypeTableViewController: UITableViewController {
    
    // @Properties
    var wodType: WODType?
    var selectedWOD: Workout?
    
    // @Injected
    var isFavorite: Bool = false
    var workouts: [Workout]!
    var service: WODListService!
    
    // @Constants
    let workoutCellIdentifier = "WorkoutNameCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWodType()
        initTitle()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Initialization
    
    func initTitle() {
        if wodType != nil {
            navigationItem.title = wodType!.rawValue
        } else {
            navigationItem.title = "Favorites"
        }
    }
    
    func initWodType() {
        if isFavorite {
            wodType = nil
            return
        }
        
        if workouts.count == 0 {
            return
        }
        
        let firstWorkout = workouts[0]
        wodType = firstWorkout.type
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workoutCellIdentifier, for: indexPath)
        cell.textLabel?.text = workouts[indexPath.row].name;
        return cell
    }
}
