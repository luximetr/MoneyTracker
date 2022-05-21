//
//  StatisticScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit
import MoneyTrackerFoundation

final class StatisticScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private var months: [Date] = []
    private var selectedMonth: Date?
    private var expenses: [Expense] = []
    var monthsClosure: (() -> [Date])?
    var expensesClosure: ((Date) -> [Expense])?
    
    override init(appearance: Appearance, locale: Locale) {
        monthPickerViewConroller = MonthPickerViewController(locale: locale)
        super.init(appearance: appearance, locale: locale)
    }
    
    private func loadData() {
        months = monthsClosure?() ?? []
        let currentMonth = (selectedMonth ?? Date()).startOfMonth
        selectedMonth = months.min(by: { abs($0.timeIntervalSince(currentMonth)) < abs($1.timeIntervalSince(currentMonth)) }) ?? currentMonth
        expenses = expensesClosure?(Date()) ?? []
    }
    
    func deleteExpense(_ expense: Expense) {
        loadData()
        setContent()
    }
    
    func editExpense(_ expense: Expense) {
        loadData()
        setContent()
    }
    
    func addExpense(_ expense: Expense) {
        loadData()
        setContent()
    }
    
    func addExpenses(_ expenses: [Expense]) {
        guard !expenses.isEmpty else { return }
        loadData()
        setContent()
    }
    
    // MARK: View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private let monthPickerViewConroller: MonthPickerViewController
    private let monthCategoryExpensesTableViewController = AUIEmptyTableViewController()
    private let monthCategoryExpensesTableViewSectionController = AUIEmptyTableViewSectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setContent()
        monthPickerViewConroller.monthPickerView = screenView.monthPickerView
        monthPickerViewConroller.didSelectMonthClosure = { [weak self] month in
            guard let self = self else { return }
            self.didSelectMonth(month)
        }
        monthCategoryExpensesTableViewController.tableView = screenView.monthCategoriesExpensesTableView
        if let month = selectedMonth {
            monthPickerViewConroller.setSelectedMonth(month)
        }
    }
        
    // MARK: Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "StatisticScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        localizer.changeLocale(locale)
        monthPickerViewConroller.changeLocale(locale)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        monthPickerViewConroller.setMonths(months)
        monthPickerViewConroller.setSelectedMonth(selectedMonth)
        setMonthExpensesLabelContent()
        setMonthCategoryExpensesTableViewControllerContent()
    }
    
    // MARK: Events
    
    private func didSelectMonth(_ month: Date) {
        selectedMonth = month
        expenses = expensesClosure?(month) ?? []
        setMonthExpensesLabelContent()
        setMonthCategoryExpensesTableViewControllerContent()
    }
    
    private func setMonthExpensesLabelContent() {
//        let currenciesAmounts = Dictionary(grouping: expenses, by: { $0.account.currency })
//        let gg = Dictionary(uniqueKeysWithValues: currenciesAmounts.map({ ($0, $1.map({ $0.amount }).reduce(into: Decimal(), +)) }))
        var currenciesAmount: [Currency: Decimal] = [:]
        for expense in expenses {
            let currency = expense.account.currency
            let amount = expense.amount
            let currencyAmount = (currenciesAmount[currency] ?? .zero) + amount
            currenciesAmount[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmount.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let currencyAmountString = "\(amount) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        screenView.monthExpensesLabel.text = currenciesAmountsStringsJoined
    }
    
    private func setMonthCategoryExpensesTableViewControllerContent() {
        monthCategoryExpensesTableViewSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        let categoriesExpenses = Dictionary(grouping: expenses) { $0.category }.values.sorted(by: { $0.first?.category.name ?? "" < $1.first?.category.name ?? "" })
        for categoryExpenses in categoriesExpenses {
            let cellController = createMonthCategoryExpensesTableViewController(expenses: categoryExpenses)
            cellControllers.append(cellController)
        }
        monthCategoryExpensesTableViewSectionController.cellControllers = cellControllers
        monthCategoryExpensesTableViewController.sectionControllers = [monthCategoryExpensesTableViewSectionController]
        monthCategoryExpensesTableViewController.reload()
    }
    
    private func createMonthCategoryExpensesTableViewController(expenses: [Expense]) -> AUITableViewCellController {
        let cellController = MonthCategoryExpensesTableViewCellController(appearance: appearance, expenses: expenses)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.monthCategoryExpensesTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.monthCategoryExpensesTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.monthCategoryExpensesTableViewCellHeight()
        }
        return cellController
    }
    
    private var monthCategoryExpensesCellControllers: [MonthCategoryExpensesTableViewCellController] {
        return monthCategoryExpensesTableViewSectionController.cellControllers.compactMap { $0 as? MonthCategoryExpensesTableViewCellController }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        monthCategoryExpensesCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
}
