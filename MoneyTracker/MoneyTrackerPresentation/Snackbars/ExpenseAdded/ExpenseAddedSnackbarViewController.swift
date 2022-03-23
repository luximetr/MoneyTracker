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
    
    let expense: Expense
    
    // MARK: Initializer
    
    init(expense: Expense) {
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
        expenseAddedSnackbarView?.messageLabel.text = "Expense added"
    }
  
    override func unsetupView() {
        super.unsetupView()
        unsetupExpenseAddedSnackbarView()
    }
  
    func unsetupExpenseAddedSnackbarView() {
    
    }
    
}
