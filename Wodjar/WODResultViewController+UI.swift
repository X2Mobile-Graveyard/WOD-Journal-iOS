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
        
        if controllerMode == .editMode {
            setupForViewMode()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(didTapSaveButton(_:)))
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
                                                            action: #selector(didTapEditButton(_:)))
        
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.isEnabled = false
        
        deleteButton.isHidden = true
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
        resultTextField.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
        switch result.resultType {
        case .weight:
            resultTextField.keyboardType = .decimalPad
        case .time:
            if let resultTime = result.resultTime {
                wodTimePicker.timeInterval = TimeInterval(resultTime)
            }
            resultTextField.inputView = wodTimePicker
            resultTextField.inputAccessoryView = createKeyboardToolbar(cancelButton: "Cancel",
                                                                       with: #selector(didTapCancelPicker),
                                                                       doneButton: "Done",
                                                                       doneSelector: #selector(didTapDoneOnTimePicker))
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
        notesTextView.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancelPicker))
    }
    
    private func setupCalendarTextField() {
        dateButton.setTitle(result.date.getDateAsWodJournalString(), for: .normal)
        pickedDateFromDatePicker = result.date
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didPickDate(datePicker:)), for: .valueChanged)
        dateTextField.inputAccessoryView = createKeyboardToolbar(cancelButton: "Cancel",
                                                                 with: #selector(didTapCancelPicker),
                                                                 doneButton: "Done",
                                                                 doneSelector: #selector(didTapDoneOnDatePicker))
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTextField))
        view.addGestureRecognizer(tap)
    }
    
    private func setupImageView() {
        guard let imageUrl = result.photoUrl else {
            return
        }
        
        self.addPictureButton.isHidden = true
        self.addUserPictureToView()
        self.viewState = .withImage
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
    }
}
