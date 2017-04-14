//
//  WODResultViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/4/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import MBProgressHUD

class WODResultViewController: WODJournalResultViewController {
    
    // @IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var rxSwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateTextField: DateTextField!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var wodTimePicker: WODTimeIntervalPicker!
    
    // @Injected
    var result: WODResult!
    var controllerMode: ControllerType!
    var service: WODResultService!
    var wod: Workout!
    
    // @Properties
    var resultCopy: WODResult!
    var pickedDateFromDatePicker: Date?
    var pickedTimeFromTimePicker: Time = Time()
    var wodResultDelegate: WodResultDelegate?
    
    // @Constants
    let fullImageSegueIdentifier = "DisplayFullImageSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        createWorkingCopy()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultTextField.becomeFirstResponder()
    }
    
    // MARK: - Helper Methods
    
    func createWorkingCopy() {
        resultCopy = WODResult(wodResult: result)
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapAddPictureButton(_ sender: Any) {
        view.endEditing(true)
        presentAlertControllerForTakingPicture()
    }
    
    @IBAction func didTapChangeDateButton(_ sender: Any) {
        dateTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapDeleteResultButton(_ sender: Any) {
        showDeleteAlert(with: "Warning",
                        message: "This action will permanently delete this result.",
                        actionButtonTitle: "Delete") { (action) in
                            self.deleteResult()
        }
    }
    
    @IBAction func didTapImageView(_ sender: Any) {
        performSegue(withIdentifier: fullImageSegueIdentifier, sender: self)
    }
    
    @IBAction func didTapChangePictureButton(_ sender: Any) {
        view.endEditing(true)
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        view.endEditing(true)
        resultCopy.updateResult(from: resultTextField.text)
        resultCopy.notes = notesTextView.text
        if controllerMode == .createMode {
            createResult()
        } else {
            updateResult()
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Other Actions
    
    func didPickDate(datePicker: UIDatePicker) {
        pickedDateFromDatePicker = datePicker.date
        resultCopy.date = pickedDateFromDatePicker!
    }
    
    func didTapOutsideTextField() {
        view.endEditing(true)
    }
    
    func didTapCancelPicker() {
        self.view.endEditing(true)
    }
    
    func didTapDoneOnDatePicker() {
        dateTextField.text = pickedDateFromDatePicker?.getDateAsWodJournalString()
        self.view.endEditing(true)
    }
    
    func didTapDoneOnTimePicker() {
        resultTextField.text = wodTimePicker.timeIntervalAsHoursMinutesSeconds.getFormatedString()
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == fullImageSegueIdentifier {
            guard let image = userImage else {
                return
            }
            let fullImageViewController = segue.destination as! FullSizeImageViewController
            fullImageViewController.image = image
        }
    }
    
    // MARK: - Service Calls
    
    func deleteResult() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.delete(wodResult: resultCopy) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success(_):
                if self.resultCopy.id != nil {
                    self.wodResultDelegate?.didDelete(result: self.resultCopy)
                }
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    func createResult() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.add(wodResult: resultCopy, with: pickedImagePath) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(id):
                self.resultCopy.id = id
                self.result.updateValues(from: self.resultCopy)
                self.wodResultDelegate?.didCreate(result: self.result)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    func updateResult() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(wodResult: resultCopy, with: pickedImagePath) { (result) in
            switch result {
            case .success():
                self.result.updateValues(from: self.resultCopy)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
}

extension WODResultViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == notesTextView {
            resultCopy.notes = textView.text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            textView.text = resultCopy.notes
        }
    }
}
