//
//  InputDateViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class InputDateViewController: EmptyViewController, AUIControlControllerDidValueChangedObserver {
    
    // MARK: Components
    
    private let datePickerController = AUIEmptyDateTimePickerController()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        datePickerController.mode = .date
        datePickerController.addDidValueChangedObserver(self)
        setContent()
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
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupInputDateView()
    }
  
    func unsetupInputDateView() {
        datePickerController.datePicker = nil
    }
    
    var didSelectDayClosure: ((Date) -> Void)?
    func controlControllerDidValueChanged(_ controlController: AUIControlController) {
        didSelectDayClosure?(datePickerController.date)
    }
    
    var selectedDay: Date {
        return datePickerController.date
    }
    
    // MARK: - Language
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "InputDateViewStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        localizer.changeLanguage(language)
        setContent()
    }
    
    func setContent() {
        let locale = Locale(identifier: localizer.localizeText("datePickerLocale"))
        datePickerController.locale = locale
    }
    
}
}
