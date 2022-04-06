//
//  ExpenseAddedSnackbarViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 23.03.2022.
//

import UIKit
import AUIKit

final class ExpenseAddedSnackbarViewController: AUIEmptyViewController {
    
    // MARK: Data
    
    let template: ExpenseTemplate
    let expense: Expense
    var okClosure: (() -> ())?
    
    // MARK: Initializer
    
    init(template: ExpenseTemplate, expense: Expense) {
        self.template = template
        self.expense = expense
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
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "ExpenseAddedSnackbarStrings")
        return localizer
    }()
    
    private func setContent() {
        expenseAddedSnackbarView?.messageLabel.text = localizer.localizeText("message", template.name)
        expenseAddedSnackbarView?.okButton.setTitle(localizer.localizeText("ok"), for: .normal)
    }
    
    // MARK: Events
    
    @objc func okButtonTouchUpInsideEventAction() {
        okClosure?()
    }
    
}
