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
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    // MARK: Data
    
    let expense: Expense
    
    // MARK: Initializer
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    // MARK: Cell
    
    private var expenseTableViewCell: ExpenseTableViewCell? {
        return tableViewCell as? ExpenseTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellForRowAtIndexPathClosure?(indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        cell.accountLabel.text = expense.account.name
        cell.categoryLabel.text = expense.category.name
        cell.amountLabel.text = "\(Self.amountNumberFormatter.string(for: expense.amount) ?? "") \(expense.account.currency.rawValue.uppercased())"
        cell.commentLabel.text = expense.comment
        return cell
    }
    
}
}
