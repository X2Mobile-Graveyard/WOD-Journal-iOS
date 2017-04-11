//
//  WODResultViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/4/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

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
        
    }
    
    @IBAction func didTapImageView(_ sender: Any) {
        performSegue(withIdentifier: fullImageSegueIdentifier, sender: self)
    }
    
    @IBAction func didTapChangePictureButton(_ sender: Any) {
        view.endEditing(true)
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Other Actions
    
    func didPickDate(datePicker: UIDatePicker) {
        pickedDateFromDatePicker = datePicker.date
        result.date = pickedDateFromDatePicker!
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
            let fullImageViewController = segue.destination as! FullSizeImageViewController
            fullImageViewController.image = userImage
        }
    }
    
}
