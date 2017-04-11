//
//  PersonalRecordViewController+UI.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage

extension PersonalRecordViewController {
    
    // MARK: - UI Initialization
    
    func initUI() {
        setupResultTextField()
        setupSegmentedControl()
        setupTitleTextField()
        setupScrollView()
        setupRXSwitch()
        setupViewForRecordType()
        setupResultTypeLabel()
        setupNotesTextView()
        setupCalendarTextField()
        setupGestureRecognizer()
        hideKeyboardWhenTappedAround()
        setupImageView()
    }
    
    func setupResultTextField() {
        resultTextField.placeholder = "Result"
        if personalRecord.resultAsString() == nil{
            return
        }
        
        resultTextField.text = personalRecord.resultAsString()
    }
    
    func changeUIForEditMode() {
        setupTitleTextField()
        setupSegmentedControl()
    }
    
    func setupFirstResponder() {
        if personalRecord.name == nil {
            titleTextField.becomeFirstResponder()
        } else {
            resultTextField.becomeFirstResponder()
        }
    }
    
    private func setupTitleTextField() {
        if controllerMode == .editMode {
            titleTextField.text = personalRecord.name!
            titleTextField.isUserInteractionEnabled = false
            editTitleButton.isHidden = true
            editTitleButton.isUserInteractionEnabled = false
            return
        }
        
        if personalRecord.name != nil {
            titleTextField.text = personalRecord.name!
        }
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupRXSwitch() {
        rxSwitch.isOn = personalRecord.rx
    }
    
    func setupViewForRecordType() {
        resultTextField.inputView = nil
        resultTextField.inputAccessoryView = nil
        switch recordType {
        case .weight:
            resultTextField.keyboardType = .decimalPad
        case .time:
            if let resultTime = personalRecord.resultTime {
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
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if personalRecord.unitType == .imperial {
                resultTypeLabel.text = "Weight Lifted (lb):"
            } else {
                resultTypeLabel.text = "Weight Lifted (kg):"
            }
        case 1:
            resultTypeLabel.text = "Rounds/Reps completed:"
        default:
            resultTypeLabel.text = "Time (mm:ss):"
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = personalRecord.resultType.hash()
        recordType = personalRecord.resultType
        if controllerMode == .editMode {
            return
        } else {
            segmentedControl.addTarget(self, action: #selector(didChangeSegmentControl(segmentControl:)), for: .valueChanged)
        }
    }
    
    func removeSegmentedControlIfNeeded() {
        if controllerMode == .editMode {
            removeSegmentedControll()
        }
    }
    
    private func setupGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapPicture(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(singleTap)
    }
    
    private func setupNotesTextView() {
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        notesTextView.layer.borderColor = color
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.cornerRadius = 5
        notesTextView.placeholder = "Optional notes..."
        if personalRecord.notes != nil {
            notesTextView.text = personalRecord.notes
        }
        addKeyboardToolbarTo(textView: notesTextView)
    }
    
    private func setupCalendarTextField() {
        calendarTextField.text = personalRecord.date.getDateAsWodJournalString()
        pickedDateFromDatePicker = personalRecord.date
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        calendarTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didPickDate(datePicker:)), for: .valueChanged)
        addKeyboardToolbarTo(textField: calendarTextField)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTextField))
        view.addGestureRecognizer(tap)
    }
    
    private func setupImageView() {
        guard let imageUrl = personalRecord.imageUrl else {
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
    
    // MARK: - Picture View Helper Methods
    
    
    
    private func removeSegmentedControll() {
        segmentedControl.removeFromSuperview()
        resultTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        resultTypeLabelTopConstraint.isActive = false
        
        let top = NSLayoutConstraint(item: resultTypeLabel,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: contentView,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: viewInset)
        view.addConstraint(top)
    }
}
