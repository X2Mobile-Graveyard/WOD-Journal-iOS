//
//  PersonalRecordViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import UITextView_Placeholder

enum ViewControllerState {
    case withImage
    case withoutImage
}

enum ControllerType {
    case editMode
    case createMode
}

class PersonalRecordViewController: UIViewController {

    // @IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var resultTypeLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var calendarTextField: DateTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var userPictureView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var footerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var rxSwitch: UISwitch!
    @IBOutlet weak var editTitleButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // @Properties
    var userImage: UIImage?
    var pickedDateFromDatePicker: Date?
    var pickedTimeFromTimePicker: Time = Time()
    var viewState: ViewControllerState = .withoutImage
    var recordType: WODCategory = .weight
    var timePicker: UIPickerView?
    var personalRecordCopy: PersonalRecord!
    var createRecordDelegate: PersonalRecordCreateDelegate?
    var updatePersonalRecordDelegate: UpdatePersonalRecordDelegate?
    
    // @Constants
    let presentFullImageSegueIdentifier = "presentFullImageSegueIdentifier"
    let viewInset: CGFloat = 16
    let imageRatio: CGFloat = 0.679
    
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
    
    // MARK: - Helper Methods
    
    func createWorkingCopy() {
        personalRecordCopy = PersonalRecord(personalRecord: personalRecord)
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapEditButton(_ sender: Any) {
        titleTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapTakeAPictureButton(_ sender: Any) {
        presentAlertControllerForTakingPicture()
    }
    
    @IBAction func didTapEditPictureButton(_ sender: Any) {
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        personalRecordCopy.rx = rxSwitch.isOn
        personalRecordCopy.result = resultTextField.text
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        calendarTextField.text = dateFormatter.string(from: pickedDateFromDatePicker!)
        self.view.endEditing(true)
    }
    
    func didTapDoneOnTimePicker() {
        resultTextField.text = pickedTimeFromTimePicker.getFormatedString()
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
        service.update(personalRecord: personalRecordCopy, with: { (result) in
            switch result {
            case .success():
                self.personalRecord.updateValues(from: self.personalRecordCopy)
            case .failure(_):
                self.handleError(result: result)
            }
        })
    }
    
    func createRecord() {
        service.create(personalRecord: personalRecordCopy, with: { (result) in
            switch result {
            case let .success(id):
                self.personalRecord.updateValues(from: self.personalRecordCopy)
                self.personalRecord.id = id
                self.createRecordDelegate?.didCreate(personalRecord: self.personalRecord)
                self.updatePersonalRecordDelegate?.didAdd(personalRecord: self.personalRecord)
                self.controllerMode = .editMode
                self.changeUIForEditMode()
            case .failure(_):
                self.handleError(result: result)
            }
        })
    }
    
    // MARK: - Modal Presentations
    
    func presentAlertControllerForTakingPicture() {
        let alertController = createAlertControllerForTakePhoto()
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertControllerForEditingPicture() {
        let alertController = createAlertControllerForEditPhoto()
        present(alertController, animated: true, completion: nil)
    }
    
    func presentErrorAlertController(with message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
}

extension PersonalRecordViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == notesTextView {
            personalRecordCopy.notes = textView.text
        }
    }
}

extension PersonalRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            if let enteredName = textField.text {
                personalRecordCopy.name = enteredName
            }
        }
        
        if textField == resultTextField {
            if let enteredResult = textField.text {
                personalRecordCopy.result = enteredResult
            }
        }
    }
}
