//
//  MonthCategoryExpensesTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthCategoryExpensesTableViewCellController: AUIClosuresTableViewCellController {
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    // MARK: Data
    
    let expenses: [Expense]
    
    // MARK: Initializer
    
    init(expenses: [Expense]) {
        self.expenses = expenses
    }
    
    // MARK: Cell
    
    private var monthCategoryExpensesTableViewCell: MonthCategoryExpensesTableViewCell? {
        return tableViewCell as? MonthCategoryExpensesTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? MonthCategoryExpensesTableViewCell else { return UITableViewCell() }
        cell.categoryLabel.text = expenses.first?.category.name
        cell.amountLabel.text = setDayExpensesContent()
        return cell
    }
    
    private func setDayExpensesContent() -> String {
        var currenciesAmounts: [Currency: Decimal] = [:]
        for expense in expenses {
            let currency = expense.account.currency
            let amount = expense.amount
            let currencyAmount = (currenciesAmounts[currency] ?? .zero) + amount
            currenciesAmounts[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmounts.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let currencyAmountString = "\(amount) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        return currenciesAmountsStringsJoined
    }
}
}
