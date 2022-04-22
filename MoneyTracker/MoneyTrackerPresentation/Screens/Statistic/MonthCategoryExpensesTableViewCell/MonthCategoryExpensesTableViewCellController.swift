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
    
    private(set) var appearance: Appearance
    let expenses: [Expense]
    private var category: Category? {
        return expenses.first?.category
    }
    
    // MARK: Initializer
    
    init(appearance: Appearance, expenses: [Expense]) {
        self.appearance = appearance
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
        if let category = category {
            cell.categoryIconView.setIcon(named: category.iconName)
        }
        setAppearance(appearance)
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
    
    // MARK: - Appearance
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        if let category = expenses.first?.category {
            let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
            monthCategoryExpensesTableViewCell?.categoryIconView.backgroundColor = categoryUIColor
            monthCategoryExpensesTableViewCell?.amountLabel.textColor = categoryUIColor
            monthCategoryExpensesTableViewCell?.categoryLabel.textColor = categoryUIColor
        }
    }
}
}
