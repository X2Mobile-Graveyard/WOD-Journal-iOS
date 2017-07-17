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
    func didAdd(personalRecord: PersonalRecord)
    func didDelete(personalRecord: PersonalRecord)
    func didUpdate(personalRecord: PersonalRecord)
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
        setupTextField()
        setupTableView()
        setupTitle()
        getResultsForPersonalRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if personalRecordType.records.count > 0 {
            personalRecordType.records = service.sortResultsByDate(result: personalRecordType.records)
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - Initialization
    
    func setupTextField() {
        let toolbar = createKeyboardToolbar(cancelButton: "Cancel",
                                            with: #selector(didTapCancelTitleTextField),
                                            doneButton: "Done",
                                            doneSelector: #selector(didTapDoneOnToolbar))
        titleTextField.inputAccessoryView = toolbar
    }
    
    private func getResultsForPersonalRecords() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.getPersonalRecordResult(for: personalRecordType.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
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
        if personalRecordType.name != nil {
            titleTextField.text = personalRecordType.name!
        }
        
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
        tableView.tableFooterView = UIView()
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
        showDeleteAlert(with: "Warning",
                        message: "This action will delete all registered records. Do you wish to continue?",
                        actionButtonTitle: "Delete") { (action) in
                self.deleteAllRecords()
        }
    }
    
    @IBAction func didTapEditTitleButton(_ sender: Any) {
        titleTextField.becomeFirstResponder()
    }
    
    func didTapCancelTitleTextField() {
        if personalRecordType.name == nil {
            return
        }
        titleTextField.text = personalRecordType.name
        titleTextField.resignFirstResponder()
    }
    
    func didTapDoneOnToolbar() {
        if titleTextField.text?.characters.count == 0 {
            return
        }
        
        updatePersonalRecordType(name: titleTextField.text!)
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
        }
        
        if identifier == personalRecordSegueIdentifier {
            if selectedPersoanlRecord == nil {
                return
            }
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.personalRecord = selectedPersoanlRecord
            personalRecordViewController.controllerMode = .editMode
            personalRecordViewController.updatePersonalRecordDelegate = self
            personalRecordViewController.personalRecordType = personalRecordType
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl(),
                                                                         s3RemoteService: S3RemoteService())
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
            personalRecordViewController.personalRecordType = personalRecordType
            personalRecordViewController.service = PersonalRecordService(remoteService: PersonalRecordRemoteServiceImpl(),
                                                                         s3RemoteService: S3RemoteService())
        }
    }
    
    // MARK: - Service Calls
    
    func deleteAllRecords() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deleteAllRecords(for: personalRecordType) { (result) in
            switch result {
            case .success():
                self.deleteTypeDelegate?.didDelete(personalRecordType: self.personalRecordType)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func deletePersonal(recordResult: PersonalRecord) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        service.deletePersonalRecordResult(with: recordResult.id!) { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func updatePersonalRecordType(name: String) {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(personalRecordTypeId: personalRecordType.id, with: name) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success():
                self.personalRecordType.name = name
                self.personalRecordType.updatedAt = Date()
            case .failure(_):
                self.handleError(result: result)
                self.titleTextField.text = self.personalRecordType.name
            }
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
        if editingStyle != .delete {
            return
        }
        let personalRecordToDelete = personalRecordType.records[indexPath.row]
        personalRecordType.records.remove(at: indexPath.row)
        personalRecordType.updateBestRecord()
        deletePersonal(recordResult: personalRecordToDelete)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPersoanlRecord = personalRecordType.records[indexPath.row]
        performSegue(withIdentifier: personalRecordSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonalRecordDetailsListViewController: UpdatePersonalRecordDelegate {
    func didDelete(personalRecord: PersonalRecord) {
        if let indexToDelete = personalRecordType.records.index(where: {$0.id! == personalRecord.id!}) {
            personalRecordType.records.remove(at: indexToDelete)
            personalRecordType.updateBestRecord()
        }
    }
    
    func didAdd(personalRecord: PersonalRecord) {
        personalRecordType.add(personalRecord: personalRecord)
        personalRecordType.initBestRecord(with: personalRecord)
    }
    
    func didUpdate(personalRecord: PersonalRecord) {
        personalRecordType.initBestRecord(with: personalRecord)
    }
}
