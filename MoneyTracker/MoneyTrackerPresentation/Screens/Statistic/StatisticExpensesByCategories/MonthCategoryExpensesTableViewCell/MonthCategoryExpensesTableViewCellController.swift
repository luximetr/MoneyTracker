//
//  MonthCategoryExpensesTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit
import AFoundation

extension StatisticExpensesByCategoriesScreenViewController {
final class MonthCategoryExpensesTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    private var appearance: Appearance
    private let categoryMonthExpenses: CategoryMonthExpenses
    private let fundsAmountNumberFormatter: NumberFormatter
    
    // MARK: Initializer
    
    init(appearance: Appearance, categoryMonthExpenses: CategoryMonthExpenses, fundsAmountNumberFormatter: NumberFormatter) {
        self.appearance = appearance
        self.categoryMonthExpenses = categoryMonthExpenses
        self.fundsAmountNumberFormatter = fundsAmountNumberFormatter
        super.init()
    }
    
    // MARK: Cell
    
    private var monthCategoryExpensesTableViewCell: MonthCategoryExpensesTableViewCell? {
        return tableViewCell as? MonthCategoryExpensesTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? MonthCategoryExpensesTableViewCell else { return UITableViewCell() }
        let category = categoryMonthExpenses.category
        cell.categoryIconView.setIcon(named: category.iconName)
        cell.categoryLabel.text = category.name
        cell.amountLabel.text = setDayExpensesContent()
        setAppearance(appearance)
        return cell
    }
    
    // MARK: Content
    
    private func setDayExpensesContent() -> String {
        var currenciesAmounts: [Currency: Decimal] = [:]
        for expense in categoryMonthExpenses.expenses.currenciesMoneyAmount {
            let currency = expense.currency
            let amount = expense.amount
            let currencyAmount = (currenciesAmounts[currency] ?? .zero) + amount
            currenciesAmounts[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmounts.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let fundsString = fundsAmountNumberFormatter.string(amount)
            let currencyAmountString = "\(fundsString) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        return currenciesAmountsStringsJoined
    }
    
    // MARK: - Appearance
    
    private let uiColorProvider = CategoryColorUIColorProvider()
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        let category = categoryMonthExpenses.category
        let categoryUIColor = uiColorProvider.getUIColor(categoryColor: category.color, appearance: appearance)
        monthCategoryExpensesTableViewCell?.categoryIconView.backgroundColor = categoryUIColor
        monthCategoryExpensesTableViewCell?.amountLabel.textColor = categoryUIColor
        monthCategoryExpensesTableViewCell?.categoryLabel.textColor = categoryUIColor
    }
}
}
