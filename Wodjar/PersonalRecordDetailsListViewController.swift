//
//  PersonalRecordDetailsListViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol UpdatePersonalRecordDelegate {
    func didDelete(personalRecord: PersonalRecord)
    func didAdd(personalRecord: PersonalRecord)
}

class PersonalRecordDetailsListViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet weak var editTitleButton: UIButton!
    
    // @Injected
    var personalRecordType: PersonalRecordType!
    var service: PersonalRecordListService!
    
    // @Constants
    let personalRecordSegueIdentifier = "goToPersonalRecordIdentifier"
    let cellIdentifier = "personalRecordDetailCelldentifier"
    let newPersonalRecordSegueIdentifier = "goToNewPersonalRecordViewController"
    
    // @Properties
    var selectedPersoanlRecord: PersonalRecord?
    var deleteTypeDelegate: PersonalRecordTypeDeleteDelegate?
    var loginDelegate: LoginDelegate?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTitle()
        getResultsForPersonalRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Initialization
    
    private func getResultsForPersonalRecords() {
        MBProgressHUD.showAdded(to: tableView, animated: true)
        service.getPersonalRecordResult(for: personalRecordType.name) { (result) in
            MBProgressHUD.hide(for: self.tableView, animated: true)
            switch result {
            case let .success(prResults):
                self.personalRecordType.records = prResults
                if prResults.count > 0 {
                    self.personalRecordType.defaultResultType = prResults[0].resultType
                }
                self.tableView.reloadData()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    private func setupTitle() {
        if !UserManager.sharedInstance.isAuthenticated() {
            titleTextField.isEnabled = false
            editTitleButton.isHidden = true
            return
        }
        
        if personalRecordType.name != nil {
            titleTextField.text = personalRecordType.name!
        } else {
            titleTextField.becomeFirstResponder()
        }
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapLogNewPRButton(_ sender: Any) {
        if UserManager.sharedInstance.isAuthenticated() {
           performSegue(withIdentifier: newPersonalRecordSegueIdentifier, sender: self)
            return
        }
        
        presentLoginScreen {
            self.titleTextField.isEnabled = true
            self.editTitleButton.isHidden = false
            self.getResultsForPersonalRecords()
            self.loginDelegate?.didLogin()
        }
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        showAlert(with: "Warning",
                  message: "This action will delete all registered records. Do you wish to continue?",
                  actionButtonTitle: "Delete") { (action) in
            self.deleteAllRecords()
        }
    }
    
    @IBAction func didTapEditTitleButton(_ sender: Any) {
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == personalRecordSegueIdentifier {
            if selectedPersoanlRecord == nil {
                return
            }
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.personalRecord = selectedPersoanlRecord
            personalRecordViewController.controllerMode = .editMode
            personalRecordViewController.updatePersonalRecordDelegate = self
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl())
        } else if identifier == newPersonalRecordSegueIdentifier {
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.personalRecord = PersonalRecord(name: personalRecordType.name,
                                                                         rx: false,
                                                                         result: nil,
                                                                         resultType: personalRecordType.defaultResultType ?? .weight,
                                                                         unitType: .metric,
                                                                         notes: nil,
                                                                         imageUrl: nil,
                                                                         date: Date())
            personalRecordViewController.updatePersonalRecordDelegate = self
            personalRecordViewController.controllerMode = .editMode
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl())
        }
    }
    
    // MARK: - Service Calls
    
    func deleteAllRecords() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deleteAllRecords(for: personalRecordType) { (result) in
            switch result {
            case .success():
                self.deleteTypeDelegate?.didDelete(personalRecordType: self.personalRecordType)
                self.personalRecordType.records = [PersonalRecord]()
                self.tableView.reloadData()
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func deletePersonalRecord(at index: Int) {
        let personalRecordToDelete = personalRecordType.records[index]
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deletePersonalRecord(with: personalRecordToDelete.id!) { (result) in
            switch result {
            case .success():
                self.personalRecordType.records.remove(at: index)
                self.tableView.reloadData()
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func updateRecords(name: String) {
        let recordsIds = personalRecordType.records.map { return $0.id!}
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(personalRecordsIds: recordsIds, with: name) { (result) in
            switch result {
            case .success():
                self.personalRecordType.name = name
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}

extension PersonalRecordDetailsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalRecordType.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return PersonalRecordDetailTableViewCell()
        }
        
        guard let detailsCell = cell as? PersonalRecordDetailTableViewCell else {
            return cell
        }
        
        detailsCell.populate(with: personalRecordType.records[indexPath.row])
        
        return detailsCell
    }
}

extension PersonalRecordDetailsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePersonalRecord(at: indexPath.row)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPersoanlRecord = personalRecordType.records[indexPath.row]
        performSegue(withIdentifier: personalRecordSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonalRecordDetailsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            if let newName = textField.text {
                updateRecords(name: newName)
                
            }
            titleTextField.resignFirstResponder()
        }
        
        return true
    }
}

extension PersonalRecordDetailsListViewController: UpdatePersonalRecordDelegate {
    func didDelete(personalRecord: PersonalRecord) {
        if let indexToDelete = personalRecordType.records.index(where: {$0.id! == personalRecord.id!}) {
            personalRecordType.records.remove(at: indexToDelete)
            if personalRecordType.records.count == 0 {
                personalRecordType.present = false
            }
            tableView.reloadData()
        }
    }
    
    func didAdd(personalRecord: PersonalRecord) {
        personalRecordType.records.append(personalRecord)
        if !personalRecordType.present {
            personalRecordType.present = true
        }
        tableView.reloadData()
    }
}












