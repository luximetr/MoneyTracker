//
//  ExpenseTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class ExpenseTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    var expense: Expense
    
    // MARK: Initializer
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    // MARK: Cell
    
    private var expenseTableViewCell: ExpenseTableViewCell? {
        return tableViewCell as? ExpenseTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        cell.setIsSelected(_isSelected, animated: false)
        setContent()
        return cell
    }
    
    // MARK: - Content
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private func setContent() {
        expenseTableViewCell?.accountLabel.text = expense.account.name
        expenseTableViewCell?.categoryLabel.text = expense.category.name
        expenseTableViewCell?.amountLabel.text = "\(Self.amountNumberFormatter.string(for: expense.amount) ?? "") \(expense.account.currency.rawValue.uppercased())"
        expenseTableViewCell?.commentLabel.text = expense.comment
    }
    
    // MARK: - Events
    
    func editExpense(_ expense: Expense) {
        self.expense = expense
        setContent()
        expenseTableViewCell?.setNeedsLayout()
        expenseTableViewCell?.layoutIfNeeded()
    }
    
    // MARK: - Selected
    
    private var _isSelected: Bool = false
    func setIsSelected(_ isSelected: Bool, animated: Bool) {
        self._isSelected = isSelected
        expenseTableViewCell?.setIsSelected(isSelected, animated: true)
    }
        
}
}
