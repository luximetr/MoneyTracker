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
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private lazy var localizer: ScreenLocalizer = {
        return ScreenLocalizer(language: language, stringsTableName: "DayTableViewCellStrings")
    }()
    
    private lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localizer.localizeText("dateLocale"))
        dateFormatter.dateFormat = "dd MMMM, EEE"
        return dateFormatter
    }()
    
    // MARK: Data
    
    let day: Date
    let expenses: [Expense]
    private var language: Language
    
    // MARK: Initializer
    
    init(language: Language, day: Date, expenses: [Expense]) {
        self.language = language
        self.day = day
        self.expenses = expenses
    }
    
    // MARK: Cell
    
    private var dayTableViewCell: DayTableViewCell? {
        return tableViewCell as? DayTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? DayTableViewCell else { return UITableViewCell() }
        showDay()
        cell.expensesLabel.text = contentExpensesLabel
        return cell
    }
    
    // MARK: Language
    
    func changeLanguage(_ language: Language) {
        self.language = language
        showDay()
    }
    
    // MARK: Content
    
    private var contentExpensesLabel: String {
        let currenciesExpenses = Dictionary(grouping: expenses) { $0.account.currency }
        let currenciesExpense = currenciesExpenses.mapValues({ $0.reduce(Decimal(), { $0 + $1.amount }) }).sorted(by: { $0.1 > $1.1 })
        let currenciesExpenseStrings = currenciesExpense.map({ "\(Self.amountNumberFormatter.string(from: NSDecimalNumber(decimal: $1)) ?? "") \($0.rawValue)" })
        let joinedCurrenciesExpenseStrings = currenciesExpenseStrings.joined(separator: " + ")
        return joinedCurrenciesExpenseStrings
    }
    
    private func showDay() {
        dayTableViewCell?.dayLabel.text = dayDateFormatter.string(from: day).uppercased()
    }
}
}
