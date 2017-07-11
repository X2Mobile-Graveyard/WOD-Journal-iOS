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
    func didCreatePersonalRecordType(withId id: Int, result: PersonalRecord)
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
        tableView.tableFooterView = UIView()
        getPersonalRecordTypes()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didLogin),
                                               name: NSNotification.Name(rawValue: "Auth"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedUnitType),
                                               name: NSNotification.Name(rawValue: "UnitType"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordTypes = service.orderByUpdatedDate(recordTypes: recordTypes)
        tableView.reloadData()
    }

    // MARK: - Initialization
    
    func getPersonalRecordTypes() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getPersonalRecordTypes { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(personalRecordTypes):
                self.recordTypes = self.service.orderByUpdatedDate(recordTypes: personalRecordTypes)
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
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
    
    // MARK: - Service Calls
    
    func delete(recordType: PersonalRecordType) {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deletePersonalRecord(with: recordType.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch (result) {
            case .success():
                self.recordTypes.remove(object: recordType)
                if self.resultSearchController.isActive {
                    self.filteredRecordTypes.remove(object: recordType)
                }
                self.tableView.reloadData()
            case .failure(_):
                self.tableView.reloadData()
                self.handleError(result: result)
                
            }
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
            let prService = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl(),
                                                  s3RemoteService: S3RemoteService())
            personalRecordViewController.service = prService
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
            personalRecordViewController.personalRecordType = selectedRecordType!
            personalRecordViewController.controllerMode = .editMode
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl(),
                                                                         s3RemoteService: S3RemoteService())
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
    
    func changedUnitType() {
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if !UserManager.sharedInstance.isAuthenticated() {
            return
        }
        
        if editingStyle != .delete {
            return
        }
        
        var recordType: PersonalRecordType
        if resultSearchController.isActive {
            recordType = filteredRecordTypes[indexPath.row]
        } else {
            recordType = recordTypes[indexPath.row]
        }
        
        delete(recordType: recordType)
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
        
        personalRecordCell.populate(with: recordType.name! , bestRecord: recordType.bestResult)
        
        return cell
    }
}

extension PersonalRecordsListViewController: PersonalRecordCreateDelegate {
    func didCreatePersonalRecordType(withId id: Int, result: PersonalRecord) {
        let newPersonalRecordType = PersonalRecordType(id: id,
                                                       name: result.name!,
                                                       present: true,
                                                       defaultType: result.resultType,
                                                       updatedAt: nil)
        newPersonalRecordType.records.append(result)
        newPersonalRecordType.initBestRecord(with: result)
        recordTypes.append(newPersonalRecordType)
    }
}

extension PersonalRecordsListViewController: PersonalRecordTypeDeleteDelegate {
    func didDelete(personalRecordType: PersonalRecordType) {
        if let indexToDelete = recordTypes.index(where: {$0.id == personalRecordType.id}) {
            recordTypes.remove(at: indexToDelete)
            tableView.reloadData()
        }
    }
}

extension PersonalRecordsListViewController: UpdatePersonalRecordDelegate {
    func didUpdate(personalRecord: PersonalRecord) {
        return
    }

    func didAdd(personalRecord: PersonalRecord) {
        guard let selectedType = selectedRecordType else {
            return
        }
        
        selectedType.add(personalRecord: personalRecord)
        selectedType.initBestRecord(with: personalRecord)
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
