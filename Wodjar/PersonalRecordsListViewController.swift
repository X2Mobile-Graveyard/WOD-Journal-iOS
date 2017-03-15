//
//  PersonalRecordsListViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class PersonalRecordsListViewController: UIViewController {

    // @IBOutlest
    @IBOutlet var tableView: UITableView!
    
    // @Properties
    var filteredRecordTypes = [PersonalRecordType]()
    var resultSearchController = UISearchController()
    var selectedRecordType: PersonalRecordType?
    
    // @Constants
    let cellIdentifier = "PersonalRecordListCellIdentifier"
    let detailsListSequeIdentifier = "goToPersonalRecordDetailsIdentifier"
    let newPersonalRecordIdentifier = "PersonalRecordSegueIdentifier"
    
    // @Injected
    var recordTypes: [PersonalRecordType]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    
    // MARK: - UI Initialization
    
    func setupSearchController() {
        definesPresentationContext = true
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == detailsListSequeIdentifier {
            if selectedRecordType == nil {
                return
            }
            
            let detailsListViewController = segue.destination as! PersonalRecordDetailsListViewController
            detailsListViewController.personalRecordType = selectedRecordType!
        } else if identifier == newPersonalRecordIdentifier {
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.controllerMode = .createMode
            personalRecordViewController.personalRecord = PersonalRecord()
        }
    }
}

extension PersonalRecordsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredRecordTypes.removeAll(keepingCapacity: false)
        
        guard let textToSearchFor = searchController.searchBar.text else {
            return
        }
        
        filteredRecordTypes = recordTypes.filter {
            if $0.name == nil {
                return false
            }
            
            let contains = $0.name!.lowercased().contains(textToSearchFor.lowercased())
            
            return contains
        }
        
        tableView.reloadData()
    }
}

extension PersonalRecordsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultSearchController.isActive {
            selectedRecordType = filteredRecordTypes[indexPath.row]
        } else {
            selectedRecordType = recordTypes[indexPath.row]
        }
        performSegue(withIdentifier: detailsListSequeIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonalRecordsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredRecordTypes.count
        }
        
        return recordTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let personalRecordCell = cell as? PresonalRecordsListTableViewCell else {
            return cell
        }
        
        var recordType: PersonalRecordType
        if resultSearchController.isActive {
            recordType = filteredRecordTypes[indexPath.row]
        } else {
            recordType = recordTypes[indexPath.row]
        }
        
        personalRecordCell.populate(with: recordType.name! , present: recordType.present)
        
        return cell
    }
    
}
