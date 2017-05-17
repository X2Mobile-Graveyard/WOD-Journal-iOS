//
//  WODTimeIntervalPicker.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

struct Time {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    func getFormatedString() -> String {
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

class WODTimeIntervalPicker: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Public API
    
    public var timeInterval: TimeInterval {
        get {
            let hours = pickerView.selectedRow(inComponent: 0) * 60 * 60
            let minutes = pickerView.selectedRow(inComponent: 1) * 60
            let seconds = pickerView.selectedRow(inComponent: 2)
            return TimeInterval(hours + minutes + seconds)
        }
        set {
            setPickerToTimeInterval(interval: newValue, animated: false)
        }
    }
    
    public var timeIntervalAsHoursMinutesSeconds: Time {
        get {
            return secondsToHoursMinutesSeconds(seconds: Int(timeInterval))
        }
    }
    
    public func setTimeIntervalAnimated(interval: TimeInterval) {
        setPickerToTimeInterval(interval: interval, animated: true)
    }
    
    // Note that setting a font that makes the picker wider
    // than this view can cause layout problems
    public var font = UIFont.systemFont(ofSize: 17) {
        didSet {
            updateLabels()
            calculateNumberWidth()
            calculateTotalPickerWidth()
            pickerView.reloadAllComponents()
        }
    }
    
    // MARK: - UI Components
    
    private let pickerView = UIPickerView()
    
    private let hourLabel = UILabel()
    private let minuteLabel = UILabel()
    private let secondLabel = UILabel()
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setupLocalizations()
        setupLabels()
        calculateNumberWidth()
        calculateTotalPickerWidth()
        setupPickerView()
    }
    
    private func setupLabels() {
        hourLabel.text = hoursString
        addSubview(hourLabel)
        minuteLabel.text = minutesString
        addSubview(minuteLabel)
        secondLabel.text = secondsString
        addSubview(secondLabel)
        updateLabels()
    }
    
    private func updateLabels() {
        hourLabel.font = font
        hourLabel.sizeToFit()
        minuteLabel.font = font
        minuteLabel.sizeToFit()
        secondLabel.font = font
        secondLabel.sizeToFit()
    }
    
    private func calculateNumberWidth() {
        let label = UILabel()
        label.font = font
        numberWidth = 0
        for i in 0...59 {
            label.text = "\(i)"
            label.sizeToFit()
            if label.frame.width > numberWidth {
                numberWidth = label.frame.width
            }
        }
    }
    
    private func calculateTotalPickerWidth() {
        // Used to position labels
        
        totalPickerWidth = 0
        totalPickerWidth += hourLabel.bounds.width
        totalPickerWidth += minuteLabel.bounds.width
        totalPickerWidth += secondLabel.bounds.width
        totalPickerWidth += standardComponentSpacing * 2
        totalPickerWidth += extraComponentSpacing * 3
        totalPickerWidth += labelSpacing * 3
        totalPickerWidth += numberWidth * 3
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        
        // Size picker view to fit self
        let top = NSLayoutConstraint(item: pickerView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0)
        
        let bottom = NSLayoutConstraint(item: pickerView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        let leading = NSLayoutConstraint(item: pickerView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0)
        
        let trailing = NSLayoutConstraint(item: pickerView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: 0)
        
        addConstraints([top, bottom, leading, trailing])
    }
    
    // MARK: - Layout
    
    private var totalPickerWidth: CGFloat = 0
    private var numberWidth: CGFloat = 20               // Width of UILabel displaying a two digit number with standard font
    
    private let standardComponentSpacing: CGFloat = 5   // A UIPickerView has a 5 point space between components
    private let extraComponentSpacing: CGFloat = 10     // Add an additional 10 points between the components
    private let labelSpacing: CGFloat = 5               // Spacing between picker numbers and labels
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Reposition labels
        
        hourLabel.center.y = pickerView.frame.midY
        minuteLabel.center.y = pickerView.frame.midY
        secondLabel.center.y = pickerView.frame.midY
        
        let pickerMinX = bounds.midX - totalPickerWidth / 2
        hourLabel.frame.origin.x = pickerMinX + numberWidth + labelSpacing
        let space = standardComponentSpacing + extraComponentSpacing + numberWidth + labelSpacing
        minuteLabel.frame.origin.x = hourLabel.frame.maxX + space
        secondLabel.frame.origin.x = minuteLabel.frame.maxX + space
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Components(rawValue: component)! {
        case .Hour:
            return 24
        case .Minute:
            return 60
        case .Second:
            return 60
        }
    }
    
    // MARK: - Picker view delegate
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let labelWidth: CGFloat
        switch Components(rawValue: component)! {
        case .Hour:
            labelWidth = hourLabel.bounds.width
        case .Minute:
            labelWidth = minuteLabel.bounds.width
        case .Second:
            labelWidth = secondLabel.bounds.width
        }
        return numberWidth + labelWidth + labelSpacing + extraComponentSpacing
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           viewForRow row: Int,
                           forComponent component: Int,
                           reusing view: UIView?) -> UIView {
        
        // Check if view can be reused
        var newView = view
        
        if newView == nil {
            // Create new view
            let size = pickerView.rowSize(forComponent: component)
            newView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            // Setup label and add as subview
            let label = UILabel()
            label.font = font
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = false
            label.frame.size = CGSize(width: numberWidth, height: size.height)
            newView!.addSubview(label)
        }
        
        let label = newView!.subviews.first as! UILabel
        label.text = "\(row)"
        
        return newView!
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 1 {
            // Change label to singular
            switch Components(rawValue: component)! {
            case .Hour:
                hourLabel.text = hourString
            case .Minute:
                minuteLabel.text = minuteString
            case .Second:
                secondLabel.text = secondString
            }
        } else {
            // Change label to plural
            switch Components(rawValue: component)! {
            case .Hour:
                hourLabel.text = hoursString
            case .Minute:
                minuteLabel.text = minutesString
            case .Second:
                secondLabel.text = secondsString
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Helpers
    
    private func setPickerToTimeInterval(interval: TimeInterval, animated: Bool) {
        let time = secondsToHoursMinutesSeconds(seconds: Int(interval))
        pickerView.selectRow(time.hours, inComponent: 0, animated: animated)
        pickerView.selectRow(time.minutes, inComponent: 1, animated: animated)
        pickerView.selectRow(time.seconds, inComponent: 2, animated: animated)
        
        
        pickerView(pickerView, didSelectRow: time.hours, inComponent: 0)
        pickerView(pickerView, didSelectRow: time.minutes, inComponent: 1)
        pickerView(pickerView, didSelectRow: time.seconds, inComponent: 2)
    }
    
    private func secondsToHoursMinutesSeconds(seconds : Int) -> Time {
        return Time(hours: seconds / 3600, minutes: (seconds % 3600) / 60, seconds: (seconds % 3600) % 60)
    }
    
    private enum Components: Int {
        case Hour = 0
        case Minute
        case Second
    }
    
    // MARK: - Localization
    
    private var hoursString     = "hours"
    private var hourString      = "hour"
    private var minutesString   = "minutes"
    private var minuteString    = "minute"
    private var secondsString   = "seconds"
    private var secondString    = "second"
    
    private func setupLocalizations() {
        
        hoursString = "hours"
        
        hourString = "hour"
        
        minutesString = "minutes"
        
        minuteString = "minute"
        
        secondsString = "seconds"
        
        secondString = "second"
    }
}
