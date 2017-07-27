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
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var wodTimePicker: WODTimeIntervalPicker!
    @IBOutlet var dateButton: UIButton!
    
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
    lazy var dateTextField: UITextField = {
       let hiddenTextField = UITextField()
        self.view.addSubview(hiddenTextField)
        return hiddenTextField
    }()
    var shareImage: UIImage?
    
    // @Constants
    let fullImageSegueIdentifier = "DisplayFullImageSegueIdentifier"
    let shareImageSegueIdentifier = "shareImageSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeCreateWODController()
        initUI()
        createWorkingCopy()
        pickedImagePath = result.photoUrl
        if controllerMode == .createMode {
            deleteButton.isHidden = true
        }
        wodTimePicker.addTarget(self, action: #selector(didTapDoneOnTimePicker), for: .valueChanged)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedUnitType),
                                               name: NSNotification.Name(rawValue: "UnitType"),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if controllerMode != .editMode {
            resultTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper Methods
    
    func createWorkingCopy() {
        resultCopy = WODResult(wodResult: result)
    }
    
    func removeCreateWODController() {
        let lastViewControllerIndex = (navigationController?.viewControllers.count)! - 1
        if let _ = navigationController?.viewControllers[lastViewControllerIndex - 1] as? CreateCustomWODViewController {
            navigationController?.viewControllers.remove(at: lastViewControllerIndex - 1)
        }
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapAddPictureButton(_ sender: Any) {
        view.endEditing(true)
        if controllerMode == .editMode && result.resultAsString() != nil {
            shareContent()
            return
        }
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
        resultCopy.rx = rxSwitch.isOn
        if controllerMode == .createMode {
            createResult()
        } else {
            updateResult()
        }
    }
    
    func didTapEditButton(_ sender: Any) {
        controllerMode = .updateMode
        UIView.animate(withDuration: 0.3, animations: { 
            self.setupForEditMode()
        }) { (_) in
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(self.didTapSaveButton(_:)))
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
        dateButton.setTitle(pickedDateFromDatePicker?.getDateAsWodJournalString(), for: .normal)
    }
    
    func didTapOutsideTextField() {
        view.endEditing(true)
    }
    
    func didTapCancelPicker() {
        self.view.endEditing(true)
    }
    
    func didTapDoneOnTimePicker() {
        resultTextField.text = wodTimePicker.timeIntervalAsHoursMinutesSeconds.getFormatedString()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == fullImageSegueIdentifier {
            let fullImageViewController = segue.destination as! FullSizeImageViewController
            fullImageViewController.image = userImage
            fullImageViewController.imageUrl = result.photoUrl
        } else if identifier == shareImageSegueIdentifier {
            if let shareViewController = segue.destination as? ShareImageViewController {
                shareViewController.image = shareImage
                let lastVCIndex = navigationController?.viewControllers.count
                shareViewController.goBackViewController = navigationController?.viewControllers[lastVCIndex! - 2]
            }
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
        service.add(wodResult: resultCopy, for: wod, with: pickedImagePath) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case let .success(id):
                self.resultCopy.id = id
                self.result.updateValues(from: self.resultCopy)
                self.addResult()
                self.handleShare()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    func updateResult() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(wodResult: resultCopy, for: wod, with: pickedImagePath) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success():
                self.result.updateValues(from: self.resultCopy)
                self.wodResultDelegate?.didUpdate()
                self.handleShare()
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func changedUnitType() {
        setupResultTextField()
        setupResultTypeLabel()
        setupDescription()
    }
    
    func handleShare() {
        let description: String
        if wod.unit == .imperial {
            description = wod.wodDescription!
        } else {
            description = wod.metricDescription ?? wod.wodDescription!
        }
        let text = "\(description)\n\nResult: \(result.resultAsString()!)"
        guard let imageToShare = text.createShareImage() else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        shareImage = imageToShare
        performSegue(withIdentifier: shareImageSegueIdentifier, sender: self)
    }
    
    func addResult() {
        if wodResultDelegate != nil {
            self.wodResultDelegate?.didCreate(result: self.result)
            return
        }
        
        if wod.results?.count == 0 {
            wod.isCompleted = true
        }
        wod.initBestRecord(with: result)
        wod.results?.insert(result, at: 0)
    }
    
    // MARK: - Share
    
    func shareContent() {
        let textToShare = "\(wod.wodDescription!)\n\nResult: \(result.resultAsString()!)"
        guard let shareImage = textToShare.createShareImage() else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true, completion: nil)
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
