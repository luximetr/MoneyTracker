//
//  ExpenseTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class ExpenseTableViewCellController: AUIClosuresTableViewCellController {
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
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
        cell.accountLabel.text = expense.account.name
        cell.categoryLabel.text = expense.category.name
        cell.amountLabel.text = "\(Self.amountNumberFormatter.string(for: expense.amount) ?? "") \(expense.account.currency.rawValue.uppercased())"
        cell.commentLabel.text = expense.comment
        return cell
    }
    
    func editExpense(_ expense: Expense) {
        self.expense = expense
        expenseTableViewCell?.accountLabel.text = expense.account.name
        expenseTableViewCell?.categoryLabel.text = expense.category.name
        expenseTableViewCell?.amountLabel.text = "\(Self.amountNumberFormatter.string(for: expense.amount) ?? "") \(expense.account.currency.rawValue.uppercased())"
        expenseTableViewCell?.commentLabel.text = expense.comment
        expenseTableViewCell?.setNeedsLayout()
        expenseTableViewCell?.layoutIfNeeded()
    }
}
}
