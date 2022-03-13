//
//  InputDateViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class InputDateViewController: AUIEmptyViewController {
    
    // MARK:
    
    private let datePickerController = AUIEmptyDateTimePickerController()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        datePickerController.mode = .date
    }
    
    // MARK: InputDateView
  
    var inputDateView: InputDateView? {
        set { view = newValue }
        get { return view as? InputDateView }
    }
  
    override func setupView() {
        super.setupView()
        setupInputDateView()
    }
    
    func setupInputDateView() {
        datePickerController.datePicker = inputDateView?.datePicker
        inputDateView?.button.addTarget(self, action: #selector(buttonTouchUpInsideEventAction), for: .touchUpInside)
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupInputDateView()
    }
  
    func unsetupInputDateView() {
        datePickerController.datePicker = nil
        inputDateView?.button.removeTarget(self, action: #selector(buttonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func buttonTouchUpInsideEventAction() {
        datePickerController.becomeFirstResponder()
    }
    
}
}
