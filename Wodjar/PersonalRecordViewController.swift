//
//  PersonalRecordViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import MBProgressHUD

enum ViewControllerState {
    case withImage
    case withoutImage
}

enum ControllerType {
    case editMode
    case createMode
}

class PersonalRecordViewController: WODJournalResultViewController {

    // @IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var resultTypeLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var calendarTextField: DateTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var rxSwitch: UISwitch!
    @IBOutlet weak var editTitleButton: UIButton!
    @IBOutlet var resultTypeLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var wodTimePicker: WODTimeIntervalPicker!
    
    // @Properties
    var pickedDateFromDatePicker: Date?
    var pickedTimeFromTimePicker: Time = Time()
    var recordType: WODCategory = .weight
    var personalRecordCopy: PersonalRecord!
    var createRecordDelegate: PersonalRecordCreateDelegate?
    var updatePersonalRecordDelegate: UpdatePersonalRecordDelegate?
    
    // @Constants
    let presentFullImageSegueIdentifier = "presentFullImageSegueIdentifier"

    
    // @Injected
    var personalRecord: PersonalRecord!
    var controllerMode: ControllerType!
    var service: PersonalRecordService!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createWorkingCopy()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        removeSegmentedControlIfNeeded()
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapEditButton(_ sender: Any) {
        titleTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapTakeAPictureButton(_ sender: Any) {
        endEditing()
        presentAlertControllerForTakingPicture()
    }
    
    @IBAction func didTapEditPictureButton(_ sender: Any) {
        endEditing()
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        endEditing()
        personalRecordCopy.rx = rxSwitch.isOn
        personalRecordCopy.updateResult(from: resultTextField.text)
        personalRecordCopy.notes = notesTextView.text
        personalRecordCopy.name = titleTextField.text
        if controllerMode == .createMode {
            createRecord()
        } else {
            if personalRecord.id == nil {
                createRecord()
            } else {
                updateRecord()
            }
        }
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        showDeleteAlert(with: "Warning",
                        message: "This action will permanently delete this record.",
                        actionButtonTitle: "Delete") { (action) in
                            self.deleteRecord()
                        }
    }
    
    // MARK: - UI Elements Actions
    
    func didChangeSegmentControl(segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            recordType = .weight
        case 1:
            recordType = .amrap
        case 2:
            recordType = .time
        default:
            recordType = .weight
        }
        resultTextField.text = ""
        endEditing()
        personalRecordCopy.resultType = recordType
        setupViewForRecordType()
    }
    
    func didPickDate(datePicker: UIDatePicker) {
        pickedDateFromDatePicker = datePicker.date
        personalRecordCopy.date = pickedDateFromDatePicker!
    }
    
    func didTapCancelPicker() {
        self.view.endEditing(true)
    }
    
    func didTapDoneOnDatePicker() {
        calendarTextField.text = pickedDateFromDatePicker?.getDateAsWodJournalString()
        self.view.endEditing(true)
    }
    
    func didTapDoneOnTimePicker() {
        resultTextField.text = wodTimePicker.timeIntervalAsHoursMinutesSeconds.getFormatedString()
        view.endEditing(true)
    }
    
    // MARK: - Gesture Recognizers
    
    func didTapPicture(recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: presentFullImageSegueIdentifier, sender: self)
    }
    
    func didTapOutsideTextField() {
        if !titleTextField.isFirstResponder {
            view.endEditing(true)
            return
        }
        if (titleTextField.text?.characters.count)! > 0 {
            titleTextField.resignFirstResponder()
        }
    }
    
    // MARK: - Service Calls
    
    func updateRecord() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(personalRecord: personalRecordCopy, with: pickedImagePath) { (result) in
            switch result {
            case .success():
                self.personalRecord.updateValues(from: self.personalRecordCopy)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func createRecord() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.create(personalRecord: personalRecordCopy, with: pickedImagePath) { (result) in
            switch result {
            case let .success(id):
                self.personalRecordCopy.id = id
                self.personalRecord.updateValues(from: self.personalRecordCopy)
                self.createRecordDelegate?.didCreate(personalRecord: self.personalRecord)
                self.updatePersonalRecordDelegate?.didAdd(personalRecord: self.personalRecord)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func deleteRecord() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.delete(personalRecord: personalRecordCopy) { (result) in
            switch result {
            case .success():
                if self.personalRecordCopy.id != nil {
                    self.updatePersonalRecordDelegate?.didDelete(personalRecord: self.personalRecordCopy)
                }
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == presentFullImageSegueIdentifier {
            guard let image = userImage else {
                return
            }
            if let fullImageViewController = segue.destination as? FullSizeImageViewController {
                fullImageViewController.image = image
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func endEditing() {
        view.endEditing(true)
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
        }
    }
    
    func createWorkingCopy() {
        personalRecordCopy = PersonalRecord(personalRecord: personalRecord)
    }
    
}

extension PersonalRecordViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == notesTextView {
            
            personalRecordCopy.notes = textView.text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            textView.text = personalRecordCopy.notes
        }
    }
}

extension PersonalRecordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            if textField.text == nil {
                return false
            }
            if textField.text!.characters.count > 0 {
                textField.resignFirstResponder()
                return true
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            if let enteredName = textField.text {
                personalRecordCopy.name = enteredName
            }
        }
        
        if textField == resultTextField {
            if let enteredResult = textField.text {
                personalRecordCopy.updateResult(from: enteredResult)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != resultTextField {
            return true
        }
        
        if textField.keyboardType != .decimalPad {
            return true
        }
        
        let countdots = textField.text!.components(separatedBy: NSLocale.current.decimalSeparator!).count - 1
        
        if countdots > 0 && string.contains(NSLocale.current.decimalSeparator!) {
            return false
        }
        
        return true
    }
}
