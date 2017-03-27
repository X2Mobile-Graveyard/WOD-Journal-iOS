//
//  PersonalRecordViewController+UI.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/10/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

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
    }
    
    func setupResultTextField() {
        if personalRecord.result != nil {
            resultTextField.text = personalRecord.result
        }
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
        switch recordType {
        case .weight:
            resultTextField.keyboardType = .decimalPad
        case .time:
            if timePicker == nil {
                createPickerView()
            }
            resultTextField.inputView = timePicker!
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
    
    private func createPickerView() {
        timePicker = UIPickerView()
        timePicker?.delegate = self
        timePicker?.dataSource = self
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = personalRecord.resultType.hashValue
        recordType = personalRecord.resultType
        if controllerMode == .editMode {
            segmentedControl.isUserInteractionEnabled = false
            segmentedControl.isEnabled = false
        } else {
            segmentedControl.addTarget(self, action: #selector(didChangeSegmentControl(segmentControl:)), for: .valueChanged)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        calendarTextField.text = dateFormatter.string(from: personalRecord.date)
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
    
    func removeUserImage() {
        userPictureView.removeFromSuperview()
        footerViewBottomConstraint.isActive = true
        viewState = .withoutImage
        addPictureButton.isHidden = false
    }
    
    func setUserImage() {
        guard let image = userImage else {
            return
        }
        
        imageView.image = image
        
        if viewState == .withImage {
            return
        }
        
        addUserPictureToView()
        
        viewState = .withImage
        
        addPictureButton.isHidden = true
    }
    
    func addUserPictureToView() {
        contentView.addSubview(userPictureView)
        footerViewBottomConstraint.isActive = false
        addConstrainsForPictureView()
    }
    
    func addConstrainsForPictureView() {
        userPictureView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidth = view.bounds.size.width - 2 * viewInset
        let imageHeight = imageWidth * imageRatio
        
        
        let leading = NSLayoutConstraint(item: userPictureView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: contentView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: viewInset)
        
        let trailing = NSLayoutConstraint(item: userPictureView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: contentView,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: -viewInset)
        
        let height = NSLayoutConstraint(item: userPictureView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: imageHeight)
        
        let top = NSLayoutConstraint(item: userPictureView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: footerView,
                                     attribute: .bottom,
                                     multiplier: 1,
                                     constant: 8)
        
        let bottom = NSLayoutConstraint(item: userPictureView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: deleteButton,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: -20)
        
        view.addConstraints([leading, trailing, height, top, bottom])
    }

}
