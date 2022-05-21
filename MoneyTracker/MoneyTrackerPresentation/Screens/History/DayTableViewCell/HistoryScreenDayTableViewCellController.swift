//
//  DayTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit
import AFoundation

extension HistoryScreenViewController {
final class DayTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    private var locale: MyLocale
    let day: Date
    private var operations: [Operation]
    
    // MARK: Initializer
    
    init(locale: MyLocale, day: Date, operations: [Operation]) {
        self.locale = locale
        self.day = day
        self.operations = operations
    }
    
    // MARK: Cell
    
    private var dayTableViewCell: DayTableViewCell? {
        return tableViewCell as? DayTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let dayTableViewCell = super.cellForRowAtIndexPath(indexPath) as? DayTableViewCell else { return UITableViewCell() }
        setContent()
        return dayTableViewCell
    }
    
    // MARK: Events
    
    func setOperations(_ operations: [Operation]) {
        self.operations = operations
        setContent()
    }
    
    func changeLanguage(_ locale: MyLocale) {
        self.locale = locale
        setContent()
    }
    
    // MARK: Content
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale.locale
        dateFormatter.dateFormat = "dd MMMM, EEE"
        return dateFormatter
    }()
    
    private var contentExpensesLabel: String {
        let expenses: [Expense] = operations.compactMap { operation in
            if case let .expense(expense) = operation {
                return expense
            }
            return nil
        }
        let currenciesExpenses = Dictionary(grouping: expenses) { $0.account.currency }
        let currenciesExpense = currenciesExpenses.mapValues({ $0.reduce(Decimal(), { $0 + $1.amount }) }).sorted(by: { $0.1 > $1.1 })
        let currenciesExpenseStrings = currenciesExpense.map({ "\(Self.amountNumberFormatter.string(from: NSDecimalNumber(decimal: $1)) ?? "") \($0.rawValue)" })
        let joinedCurrenciesExpenseStrings = currenciesExpenseStrings.joined(separator: " + ")
        return joinedCurrenciesExpenseStrings
    }
    
    private func setContent() {
        let day = dayDateFormatter.string(from: day).uppercased()
        dayTableViewCell?.dayLabel.text = day
        let expenses = contentExpensesLabel
        dayTableViewCell?.expensesLabel.text = expenses
    }
}
}
