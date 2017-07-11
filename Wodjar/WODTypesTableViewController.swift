//
//  WODTypesTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol WodTypesDataSource {
    func set(workouts: [Workout], forType: WODType)
}

protocol WodTypesDelegate {
    func didCreate(wod: Workout)
    func didDelete(wod: Workout)
}

class WODTypesTableViewController: UITableViewController {
    
    // @Injected
    var service: WODListService!
    
    // @Properties
    var workoutsTypes = [WODTypeDetails]()
    var selectedType: WODType = .girl
    var girls: [Workout]?
    var heroes: [Workout]?
    var challenges: [Workout]?
    var opens: [Workout]?
    var customs: [Workout]?
    
    // @Constants
    let wodTypeCellIdentifier = "WodTypeTableViewCellIdentifier"
    let customWodsTableIdentifier = "CustomWodTypeViewControllerIdentifier"
    let defaultWodsTableIdentifier = "DefaultWodTypeViewControllerIdentifier"
    let headerHeight: CGFloat = 20
    let defaultTypes = 4
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: NSNotification.Name(rawValue: "Auth"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWods()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if workoutsTypes.count == 0 {
            return 0
        }
        if section == 0 {
            return workoutsTypes.count - 1
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wodTypeCellIdentifier, for: indexPath) as! WODTypeTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.populate(with: workoutsTypes[indexPath.row])
        case 1:
            cell.populate(with: workoutsTypes[defaultTypes + indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if workoutsTypes.count == 0 {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: tableView.frame.size.width,
                                        height: section == 0 ? headerHeight + 20 : headerHeight))
        let label = UILabel(frame: CGRect(x: 20,
                                          y: section == 0 ? 20 : 0,
                                          width: tableView.frame.size.width,
                                          height: headerHeight))
        view.backgroundColor = tableView.backgroundColor
        label.textColor = .lightGray
        view.addSubview(label)
        
        if section == 0 {
            label.text = "Library"
        } else {
            label.text = "Create Your Own"
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerHeight + 20
        }
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isCustom: Bool = false
        switch indexPath.section {
        case 0:
            selectedType = workoutsTypes[indexPath.row].type
        case 1:
            if !UserManager.sharedInstance.isAuthenticated() {
                tableView.deselectRow(at: indexPath, animated: true)
                presentLoginScreen(with: {
                    self.getWods()
                })
                return
            }
            isCustom = true
            selectedType = workoutsTypes[defaultTypes + indexPath.row].type
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
        let selectedWorkouts = getWorkoutsFor(type: selectedType)
        switch identifier {
        case customWodsTableIdentifier:
            let customVC = segue.destination as! CustomWODTypeTableViewController
            customVC.service = service
            customVC.wodType = selectedType
            customVC.workouts = customs
            customVC.wodTypeDelegate = self
            customVC.dataSource = self
        case defaultWodsTableIdentifier:
            let defaultVC = segue.destination as! DefaultWODTypeTableViewController
            defaultVC.service = service
            defaultVC.wodType = selectedType
            defaultVC.dataSource = self
            defaultVC.workouts = selectedWorkouts
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    
    func getWorkoutsFor(type: WODType) -> [Workout]?{
        switch type {
        case .challenge:
            return challenges
        case .girl:
            return girls
        case .hero:
            return heroes
        case .open:
            return opens
        case .custom:
            return customs
        }
    }
    
    // MARK: - Service Calls
    
    func getWods() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        service.getWodsTypes { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(wodTypes):
                self.workoutsTypes = wodTypes
                self.tableView.reloadData()
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

extension WODTypesTableViewController: WodTypesDataSource {
    func set(workouts: [Workout], forType type: WODType) {
        switch type {
        case .challenge:
            self.challenges = workouts
        case .girl:
            self.girls = workouts
        case .hero:
            self.heroes = workouts
        case .open:
            self.opens = workouts
        case .custom:
            self.customs = workouts
        }
    }
}

extension WODTypesTableViewController: WodTypesDelegate {
    func didDelete(wod: Workout) {
        customs?.remove(object: wod)
    }
    
    func didCreate(wod: Workout) {
        customs?.append(wod)
    }
}
