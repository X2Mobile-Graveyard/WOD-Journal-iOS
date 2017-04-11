//
//  WODResultViewController+UI.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

extension WODResultViewController {
    // MARK: - UI Initialization
    
    func initUI() {
        setupResultTextField()
        setupTitleTextField()
        setupScrollView()
        setupRXSwitch()
        setupViewForRecordType()
        setupResultTypeLabel()
        setupNotesTextView()
        setupCalendarTextField()
        hideKeyboardWhenTappedAround()
        setupImageView()
        setupDescription()
    }
    
    func setupResultTextField() {
        resultTextField.placeholder = "Result"
        if result.resultAsString() == nil {
            return
        }
        
        resultTextField.text = result.resultAsString()
    }
    
    func setupDescription() {
        if wod.wodDescription == nil {
            descriptionTextView.placeholder = "No description"
            return
        }
        
        descriptionTextView.text = wod.wodDescription!
    }
    
    func changeUIForEditMode() {
        setupTitleTextField()
    }
    
    private func setupTitleTextField() {
     navigationItem.title = wod.name
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupRXSwitch() {
        rxSwitch.isOn = result.rx
    }
    
    func setupViewForRecordType() {
        resultTextField.inputView = nil
        resultTextField.inputAccessoryView = nil
        switch result.resultType {
        case .weight:
            resultTextField.keyboardType = .decimalPad
        case .time:
            if let resultTime = result.resultTime {
                wodTimePicker.timeInterval = TimeInterval(resultTime)
            }
            resultTextField.inputView = wodTimePicker
            resultTextField.inputAccessoryView = createKeyboardToolbarForTimePicker()
        case .amrap:
            resultTextField.keyboardType = .numberPad
        default:
            break
        }
        
        setupResultTypeLabel()
    }
    
    private func setupResultTypeLabel() {
        switch result.resultType {
        case .weight:
            if UserManager.sharedInstance.unitType == .imperial {
                resultDescriptionLabel.text = "Weight Lifted (lb):"
            } else {
                resultDescriptionLabel.text = "Weight Lifted (kg):"
            }
        case .amrap:
            resultDescriptionLabel.text = "Rounds/Reps completed:"
        default:
            resultDescriptionLabel.text = "Time (mm:ss):"
        }
    }
    
    private func setupNotesTextView() {
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        notesTextView.layer.borderColor = color
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.cornerRadius = 5
        notesTextView.placeholder = "Optional notes..."
        if result.notes != nil {
            notesTextView.text = result.notes
        }
        addKeyboardToolbarTo(textView: notesTextView)
    }
    
    private func setupCalendarTextField() {
        dateTextField.text = result.date.getDateAsWodJournalString()
        pickedDateFromDatePicker = result.date
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didPickDate(datePicker:)), for: .valueChanged)
        addKeyboardToolbarTo(textField: dateTextField)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTextField))
        view.addGestureRecognizer(tap)
    }
    
    private func setupImageView() {
        guard let imageUrl = result.photoUrl else {
            return
        }
        
        imageView.sd_setImage(with: URL(string: imageUrl)) { (setImage, error, _, _) in
            self.addUserPictureToView()
            self.viewState = .withImage
            self.addPictureButton.isHidden = true
        }
    }
    
    // MARK: - Keyboard Toolbar
    
    private func addKeyboardToolbarTo(textView:UITextView) {
        let toolbarWithHideButton = createKeyboardToolbar(with: "Done")
        textView.inputAccessoryView = toolbarWithHideButton
        
    }
    
    private func addKeyboardToolbarTo(textField: UITextField) {
        let toolbar = createKeyboardToolbarForDatePicker()
        textField.inputAccessoryView = toolbar
    }
    
    private func createKeyboardToolbar(with hiddingOtion: String) -> UIToolbar {
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardItem = UIBarButtonItem(title: hiddingOtion,
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapCancelPicker))
        toolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    private func createKeyboardToolbarForDatePicker() -> UIToolbar {
        let toolbar = createKeyboardToolbar(with: "Cancel")
        
        let doneKeyboardItem = UIBarButtonItem(title: "Done",
                                               style: .done,
                                               target: self,
                                               action: #selector(didTapDoneOnDatePicker))
        toolbar.items?.append(doneKeyboardItem)
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    private func createKeyboardToolbarForTimePicker() -> UIToolbar {
        let toolbar = createKeyboardToolbar(with: "Cancel")
        
        let doneKeyboardItem = UIBarButtonItem(title: "Done",
                                               style: .done,
                                               target: self,
                                               action: #selector(didTapDoneOnTimePicker))
        toolbar.items?.append(doneKeyboardItem)
        toolbar.sizeToFit()
        
        return toolbar
    }
}
