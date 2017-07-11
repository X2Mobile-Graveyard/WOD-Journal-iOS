//
//  CreateCustomWODViewController+UI.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/12/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage

extension CreateCustomWODViewController {
    
    // MARK: - UI Initialization
    
    func initUI() {
        setupSegmentedControl()
        setupScrollView()
        setupDescriptionTextView()
        setupCalendarTextField()
    }
    
    func changeUIForEditMode() {
        setupSegmentedControl()
    }
    
    private func setupDescriptionTextView() {
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        descriptionTextView.layer.borderColor = color
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.placeholder = "Description..."
        descriptionTextView.inputAccessoryView = createKeyboardToolbarForDescription()
    }
    
    private func setupCalendarTextField() {
        dateButton.setTitle(Date().getDateAsWodJournalString(), for: .normal)
        pickedDateFromDatePicker = Date()
        customWod.date = Date()
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(didPickDate(datePicker:)), for: .valueChanged)
        dateTextField.inputAccessoryView = createKeyboardToolbar(with: "Done", selector: #selector(didTapCancel))
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentControl(segmentControl:)), for: .valueChanged)
    }
    
    private func createKeyboardToolbar(with hiddingOtion: String) -> UIToolbar {
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardItem = UIBarButtonItem(title: hiddingOtion,
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapCancel))
        toolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        toolbar.sizeToFit()
        
        return toolbar
    }

    
    private func createKeyboardToolbarForDescription() -> UIToolbar {
        let toolbar = createKeyboardToolbar(with: "Done")
        return toolbar
    }
}
