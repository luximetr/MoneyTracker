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
        setContent()
        return cell
    }
    
    func editExpense(_ expense: Expense) {
        self.expense = expense
        setContent()
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
        expenseTableViewCell?.amountLabel.text = "\(Self.amountNumberFormatter.string(for: expense.amount) ?? "") \(expense.account.currency.rawValue.uppercased())"
        expenseTableViewCell?.balanceTransferImageView.image = UIImage(systemName: expense.category.iconName)
        expenseTableViewCell?.categoryLabel.text = expense.category.name
        expenseTableViewCell?.commentLabel.text = expense.comment
        expenseTableViewCell?.setNeedsLayout()
        expenseTableViewCell?.layoutIfNeeded()
    }
}
}
