//
//  ExpenseAddedSnackbarViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 23.03.2022.
//

import UIKit
import AUIKit

final class ExpenseAddedSnackbarViewController: EmptyViewController {
    
    // MARK: Data
    
    private(set) var appearance: Appearance
    let template: ExpenseTemplate
    let expense: Expense
    var okClosure: (() -> ())?
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, template: ExpenseTemplate, expense: Expense) {
        self.appearance = appearance
        self.template = template
        self.expense = expense
        super.init(locale: locale)
    }
    
    // MARK: ExpenseAddedSnackbarView
  
    var expenseAddedSnackbarView: ExpenseAddedSnackbarView? {
        set { view = newValue }
        get { return view as? ExpenseAddedSnackbarView }
    }
  
    override func setupView() {
        super.setupView()
        setupExpenseAddedSnackbarView()
    }
  
    func setupExpenseAddedSnackbarView() {
        expenseAddedSnackbarView?.okButton.addTarget(self, action: #selector(okButtonTouchUpInsideEventAction), for: .touchUpInside)
        setContent()
    }
  
    override func unsetupView() {
        super.unsetupView()
        unsetupExpenseAddedSnackbarView()
    }
  
    func unsetupExpenseAddedSnackbarView() {
        expenseAddedSnackbarView?.okButton.removeTarget(self, action: #selector(okButtonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "ExpenseAddedSnackbarStrings")
        return localizer
    }()
    
    private func setContent() {
        expenseAddedSnackbarView?.messageLabel.text = localizer.localizeText("message", template.name)
        expenseAddedSnackbarView?.okButton.setTitle(localizer.localizeText("ok"), for: .normal)
    }
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        setContent()
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        expenseAddedSnackbarView?.changeAppearance(appearance)
    }
    
    // MARK: Events
    
    @objc func okButtonTouchUpInsideEventAction() {
        okClosure?()
    }
    
}
