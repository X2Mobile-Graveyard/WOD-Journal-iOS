//
//  PersonalRecordDetailsListViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class PersonalRecordDetailsListViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleTextField: UITextField!
    
    // @Injected
    var personalRecordType: PersonalRecordType!
    var selectedPersoanlRecord: PersonalRecord?
    
    // @Constants
    let personalRecordSegueIdentifier = "goToPersonalRecordIdentifier"
    let cellIdentifier = "personalRecordDetailCelldentifier"
    let newPersonalRecordSegueIdentifier = "goToNewPersonalRecordViewController"
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTitle()
    }
    
    // MARK: - UIInitialization
    
    private func setupTitle() {
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
        
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        
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
        } else if identifier == newPersonalRecordSegueIdentifier {
            let personalRecordViewController = segue.destination as! PersonalRecordViewController
            personalRecordViewController.personalRecord = PersonalRecord()
            personalRecordViewController.controllerMode = .createMode
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
            print("Did delete entry")
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
            titleTextField.resignFirstResponder()
        }
        
        return true
    }
}












