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
        
        if controllerMode == .editMode && personalRecord.resultAsString() != nil {
            setupForViewMode()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(didTapSave(_:)))
        }
    }
    
    func setupForViewMode() {
        resultTextField.borderStyle = .none
        resultTextField.isEnabled = false
        resultTextField.clearButtonMode = .never
        
        notesTextView.layer.borderWidth = 0.0
        notesTextView.isEditable = false
        
        rxSwitch.isEnabled = false
        
        if viewState == .withoutImage {
            addPictureButton.isHidden = true
        } else {
            changePictureBackgroundView.isHidden = true
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(didTapEditPRButton(_:)))
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.isEnabled = false
        
        deleteButton.isHidden = true
        
        titleTextField.isEnabled = false
        editTitleButton.isHidden = true
    }
    
    func setupForEditMode() {
        resultTextField.borderStyle = .roundedRect
        resultTextField.isEnabled = true
        resultTextField.clearButtonMode = .always
        
        notesTextView.layer.borderWidth = 0.5
        notesTextView.isEditable = true
        
        rxSwitch.isEnabled = true
        
        if viewState == .withoutImage {
            addPictureButton.isHidden = false
        } else {
            changePictureBackgroundView.isHidden = false
        }
        
        dateButton.setTitleColor(navigationController?.navigationBar.tintColor, for: .normal)
        dateButton.isEnabled = true
        
        deleteButton.isHidden = false
        
        titleTextField.isEnabled = true
        editTitleButton.isHidden = false
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
            if personalRecord.resultAsString() == nil {
                resultTextField.becomeFirstResponder()
            }
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
        resultTextField.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
        switch recordType {
        case .weight:
            resultTextField.keyboardType = .decimalPad
        case .time:
            if let resultTime = personalRecord.resultTime {
                wodTimePicker.timeInterval = TimeInterval(resultTime)
            }
            resultTextField.inputView = wodTimePicker
            resultTextField.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
        case .amrap:
            resultTextField.keyboardType = .numberPad
        default:
            break
        }
        
        setupResultTypeLabel()
    }
    
    func setupResultTypeLabel() {
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
        notesTextView.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
    }
    
    private func setupCalendarTextField() {
        dateButton.setTitle(personalRecord.date.getDateAsWodJournalString(), for: .normal)
        pickedDateFromDatePicker = personalRecord.date
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        calendarTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didPickDate(datePicker:)), for: .valueChanged)
        calendarTextField.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTextField))
        view.addGestureRecognizer(tap)
    }
    
    private func setupImageView() {
        guard let imageUrl = personalRecord.imageUrl else {
            return
        }
        
        self.addPictureButton.isHidden = true
        self.addUserPictureToView()
        self.viewState = .withImage
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
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
