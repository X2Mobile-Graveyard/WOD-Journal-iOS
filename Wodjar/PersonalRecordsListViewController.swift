//
//  PersonalRecordsListViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol PersonalRecordCreateDelegate {
    func didCreate(personalRecord: PersonalRecord)
}

protocol PersonalRecordTypeDeleteDelegate  {
    func didDelete(personalRecordType: PersonalRecordType)
}

class PersonalRecordsListViewController: UIViewController {

    // @IBOutlest
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    // @Properties
    var filteredRecordTypes = [PersonalRecordType]()
    var selectedRecordType: PersonalRecordType?
    lazy var resultSearchController: UISearchController = {
        [unowned self] in
        self.definesPresentationContext = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.searchBarContainer.addSubview(searchController.searchBar)
        
        return searchController
    }()
    
    lazy var defaultPRs:[PersonalRecordType] = {
        var defaultPrs = [PersonalRecordType]()
        if let path = Bundle.main.path(forResource: "defaultPRs", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            if let weightPersonalRecords = dict["Weight"] as? [String] {
                for personalRecordName in weightPersonalRecords {
                    let pr = PersonalRecordType(name: personalRecordName, present: false, defaultType: .weight)
                    defaultPrs.append(pr)
                }
            }
            
            if let timePersonalRecords = dict["Time"] as? [String] {
                for personalRecordName in timePersonalRecords {
                    let pr = PersonalRecordType(name: personalRecordName, present: false, defaultType: .time)
                    defaultPrs.append(pr)
                }
            }
        }
        
        return defaultPrs
    }()
    
    // @Constants
    let cellIdentifier = "PersonalRecordListCellIdentifier"
    let detailsListSequeIdentifier = "goToPersonalRecordDetailsIdentifier"
    let newPersonalRecordIdentifier = "PersonalRecordSegueIdentifier"
    
    // @Injected
    var recordTypes = [PersonalRecordType]()
    var service: PersonalRecordListService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPersonalRecordTypes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordTypes = service.merge(personalRecords: recordTypes, with: defaultPRs)
        tableView.reloadData()
    }

    
    // MARK: - Initialization
    
    func getPersonalRecordTypes() {
        MBProgressHUD.showAdded(to: tableView, animated: true)
        service.getPersonalRecordTypes { (result) in
            switch result {
            case let .success(personalRecordTypes):
                self.recordTypes = personalRecordTypes
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
            
            MBProgressHUD.hide(for: self.tableView, animated: true)
        }
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
            detailsListViewController.service = service
            detailsListViewController.deleteTypeDelegate = self
        } else if identifier == newPersonalRecordIdentifier {
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.controllerMode = .createMode
            personalRecordViewController.personalRecord = PersonalRecord()
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceTest())
            personalRecordViewController.createRecordDelegate = self
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

extension PersonalRecordsListViewController: PersonalRecordCreateDelegate {
    func didCreate(personalRecord: PersonalRecord) {
        let newPersonalRecordType = PersonalRecordType(name: personalRecord.name!, present: true, defaultType: personalRecord.resultType)
        newPersonalRecordType.records.append(personalRecord)
        
        recordTypes.append(newPersonalRecordType)
    }
}

extension PersonalRecordsListViewController: PersonalRecordTypeDeleteDelegate {
    func didDelete(personalRecordType: PersonalRecordType) {
        if let indexToDelete = recordTypes.index(where: {$0.name! == personalRecordType.name!}) {
            recordTypes.remove(at: indexToDelete)
            tableView.reloadData()
        }
    }
}
