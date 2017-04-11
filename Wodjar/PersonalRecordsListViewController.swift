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

protocol LoginDelegate {
    func didLogin()
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
            if let weightPersonalRecords = dict["Weight"] as? [[String: String]] {
                for personalRecordDict in weightPersonalRecords {
                    let personalRecordName = personalRecordDict["name"]
                    let updatedAt = personalRecordDict["date"]
                    let pr = PersonalRecordType(name: personalRecordName!, present: false, defaultType: .weight, updatedAt: updatedAt!)
                    defaultPrs.append(pr)
                }
            }
            
            if let timePersonalRecords = dict["Time"] as? [[String: String]] {
                for personalRecordDict in timePersonalRecords {
                    let personalRecordName = personalRecordDict["name"]
                    let updatedAt = personalRecordDict["date"]
                    let pr = PersonalRecordType(name: personalRecordName!, present: false, defaultType: .time, updatedAt: updatedAt!)
                    defaultPrs.append(pr)
                }
            }
        }
        return defaultPrs
    }()
    
    // @Constants
    let cellIdentifier = "PersonalRecordListCellIdentifier"
    let detailsListSequeIdentifier = "goToPersonalRecordDetailsIdentifier"
    let newPersonalRecordIdentifier = "NewPersonalRecordSegueIdentifier"
    let addFirstRecordIdentifier = "FirstRecordIdentifier"
    
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
        recordTypes = service.orderByUpdatedDate(recordTypes: recordTypes)
        tableView.reloadData()
    }

    // MARK: - Initialization
    
    func getPersonalRecordTypes() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getPersonalRecordTypes { (result) in
            switch result {
            case let .success(personalRecordTypes):
                self.recordTypes = self.service.orderByUpdatedDate(recordTypes: personalRecordTypes)
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapAddPRButton(_ sender: Any) {
        if UserManager.sharedInstance.isAuthenticated() {
            performSegue(withIdentifier: newPersonalRecordIdentifier, sender: self)
            return
        }
        
        presentLoginScreen {
            self.getPersonalRecordTypes()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case detailsListSequeIdentifier:
            if selectedRecordType == nil {
                return
            }
            let detailsListViewController = segue.destination as! PersonalRecordDetailsListViewController
            detailsListViewController.personalRecordType = selectedRecordType!
            detailsListViewController.service = service
            detailsListViewController.deleteTypeDelegate = self
            detailsListViewController.loginDelegate = self
        case newPersonalRecordIdentifier:
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.controllerMode = .createMode
            personalRecordViewController.personalRecord = PersonalRecord()
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl())
            personalRecordViewController.createRecordDelegate = self
        case addFirstRecordIdentifier:
            if selectedRecordType == nil {
                return
            }
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.personalRecord = PersonalRecord(name: selectedRecordType!.name,
                                                                         rx: false,
                                                                         result: nil,
                                                                         resultType: selectedRecordType!.defaultResultType ?? .weight,
                                                                         unitType: .metric,
                                                                         notes: nil,
                                                                         imageUrl: nil,
                                                                         date: Date())
            personalRecordViewController.updatePersonalRecordDelegate = self
            personalRecordViewController.controllerMode = .editMode
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl())
        default:
            break
        }
    }
    
    func addFirstRecordForSelectedRecordType() {
        if UserManager.sharedInstance.isAuthenticated() {
            performSegue(withIdentifier: addFirstRecordIdentifier, sender: self)
            return
        }
        
        presentLoginScreen { 
            self.getPersonalRecordTypes()
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
        
        if selectedRecordType!.present {
            performSegue(withIdentifier: detailsListSequeIdentifier, sender: self)
        } else {
            addFirstRecordForSelectedRecordType()
        }
        
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
        let newPersonalRecordType = PersonalRecordType(name: personalRecord.name!, present: true, defaultType: personalRecord.resultType, updatedAt: nil)
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

extension PersonalRecordsListViewController: UpdatePersonalRecordDelegate {
    func didAdd(personalRecord: PersonalRecord) {
        guard let selectedType = selectedRecordType else {
            return
        }
        
        selectedType.add(personalRecord: personalRecord)
        selectedType.updatedAt = Date()
    }
    
    func didDelete(personalRecord: PersonalRecord) {
        return
    }
}

extension PersonalRecordsListViewController: LoginDelegate {
    func didLogin() {
        self.getPersonalRecordTypes()
    }
}
