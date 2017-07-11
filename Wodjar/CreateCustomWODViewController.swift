//
//  CreateCustomWODViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/4/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import MBProgressHUD

class CreateCustomWODViewController: WODJournalResultViewController {
    
    // @IBOutlets
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateButton: UIButton!
    
    // @Injected
    var customWod: Workout!
    var service: WODService!
    
    // @Properties
    var delegate: CustomWodDelegate?
    lazy var dateTextField: UITextField = {
        let hiddenTextField = UITextField()
        self.view.addSubview(hiddenTextField)
        return hiddenTextField
    }()
    var pickedDateFromDatePicker: Date?
    
    // @Constant
    let presentFullImageSegueIdentifier = "GoToFullImageViewController"
    let footerHeight: CGFloat = 29
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    // MARK: - Buttons Actions
    
    @IBAction func didTapChangeDateButton(_ sender: Any) {
        dateTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        view.endEditing(true)
        showDeleteAlert(with: "Warning",
                        message: "This action cannot be undone.",
                        actionButtonTitle: "Delete") { (alert) in
                            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddPictureButton(_ sender: Any) {
        view.endEditing(true)
        presentAlertControllerForTakingPicture()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        customWod.wodDescription = descriptionTextView.text
        MBProgressHUD.showAdded(to: view, animated: true)
        service.create(customWod: customWod, imagePath: pickedImagePath) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(wodId):
                self.customWod.id = wodId
                self.delegate?.didCreate(customWod: self.customWod)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    @IBAction func didTapChangePictureButton(_ sender: Any) {
        view.endEditing(true)
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapOnImageView(_ sender: Any) {
        performSegue(withIdentifier: presentFullImageSegueIdentifier, sender: self)
    }
    
    // MARK: - Other Actions
    
    func didChangeSegmentControl(segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            customWod.category = .weight
        case 1:
            customWod.category = .amrap
        case 2:
            customWod.category = .time
        default:
            customWod.category = .weight
        }
        view.endEditing(true)
    }
    
    func didTapCancel() {
        view.endEditing(true)
    }
    
    func didPickDate(datePicker: UIDatePicker) {
        pickedDateFromDatePicker = datePicker.date
        customWod.date = pickedDateFromDatePicker!
        dateButton.setTitle(pickedDateFromDatePicker?.getDateAsWodJournalString(), for: .normal)
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
            
            let fullImageViewController = segue.destination as! FullSizeImageViewController
            fullImageViewController.image = image
        }
    }
    
    // MARK: - UI Overrides
    
    override func removeUserImage() {
        footerViewHeightConstraint.constant = footerHeight
        super.removeUserImage()
    }
    
    override func setUserImage() {
        footerViewHeightConstraint.constant = 0.1
        super.setUserImage()
    }
}

extension CreateCustomWODViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateCustomWODViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            customWod.wodDescription = textView.text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            textView.text = customWod.wodDescription
        }
    }
}
