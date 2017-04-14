//
//  CreateCustomWODViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/4/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class CreateCustomWODViewController: WODJournalResultViewController {
    
    // @IBOutlets
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editTitleButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var footerViewHeightConstraint: NSLayoutConstraint!
    
    // @Injected
    var customWod: Workout!
    var service: WODService!
    
    // @Properties
    var delegate: CustomWodDelegate?
    
    // @Constant
    let presentFullImageSegueIdentifier = "GoToFullImageViewController"
    let footerHeight: CGFloat = 29
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endEditing()
    }

    // MARK: - Buttons Actions
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        endEditing()
        showDeleteAlert(with: "Warning",
                        message: "This action cannot be undone.",
                        actionButtonTitle: "Delete") { (alert) in
                            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddPictureButton(_ sender: Any) {
        endEditing()
        presentAlertControllerForTakingPicture()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        customWod.name = titleTextField.text
        service.create(customWod: customWod, imagePath: pickedImagePath) { (result) in
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
        endEditing()
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapOnImageView(_ sender: Any) {
        performSegue(withIdentifier: presentFullImageSegueIdentifier, sender: self)
    }
    
    @IBAction func didTapEditTitleButton(_ sender: Any) {
        titleTextField.becomeFirstResponder()
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
        endEditing()
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
    
    func didTapDoneOnToolbar() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    func endEditing() {
        view.endEditing(true)
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
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
