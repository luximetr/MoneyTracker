//
//  StatisticScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit
import AFoundation
import MoneyTrackerFoundation

final class StatisticExpensesByCategoriesScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private var months: [Date] = []
    var monthsClosure: (() -> [Date])?
    private var selectedMonth: Date?
    private var categoriesMonthExpenses: CategoriesMonthExpenses?
    var expensesClosure: ((Date, @escaping (Result<CategoriesMonthExpenses, Swift.Error>) -> Void) -> Void)?
    var backClosure: (() -> Void)?
    
    override init(appearance: Appearance, locale: Locale) {
        monthPickerViewConroller = MonthPickerViewController(locale: locale)
        super.init(appearance: appearance, locale: locale)
    }
    
    private func loadData() {
        months = monthsClosure?() ?? []
        let currentMonth = (selectedMonth ?? Date()).startOfMonth
        selectedMonth = months.min(by: { abs($0.timeIntervalSince(currentMonth)) < abs($1.timeIntervalSince(currentMonth)) }) ?? currentMonth
        self.loadCategoriesMonthExpenses()
    }
    
    private func loadCategoriesMonthExpenses() {
        self.expensesClosure?(selectedMonth ?? Date(), { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categoriesMonthExpenses):
                self.categoriesMonthExpenses = categoriesMonthExpenses
                self.setMonthExpensesLabelContent()
                self.setMonthCategoryExpensesTableViewControllerContent()
            case .failure:
                break
            }
        })
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
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
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
        
    // MARK: - Localization
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        localizer.changeLocale(locale)
        monthPickerViewConroller.changeLocale(locale)
        fundsAmountNumberFormatter.locale = locale.foundationLocale
        setContent()
    }
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "StatisticExpensesByCategoriesScreenStrings")
        return localizer
    }()
    
    // MARK: - Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        monthPickerViewConroller.setMonths(months)
        monthPickerViewConroller.setSelectedMonth(selectedMonth)
        setMonthExpensesLabelContent()
        setMonthCategoryExpensesTableViewControllerContent()
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectMonth(_ month: Date) {
        selectedMonth = month
        self.loadCategoriesMonthExpenses()
    }
    
    private lazy var fundsAmountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale.foundationLocale
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private func setMonthExpensesLabelContent() {
        guard let expenses = categoriesMonthExpenses else { return }
        var currenciesAmount: [Currency: Decimal] = [:]
        for expense in expenses.expenses.currenciesMoneyAmount {
            let currency = expense.currency
            let amount = expense.amount
            let currencyAmount = (currenciesAmount[currency] ?? .zero) + amount
            currenciesAmount[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmount.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let fundsAmountString = fundsAmountNumberFormatter.string(amount)
            let currencyAmountString = "\(fundsAmountString) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        screenView.monthExpensesLabel.text = currenciesAmountsStringsJoined
    }
    
    private func setMonthCategoryExpensesTableViewControllerContent() {
        monthCategoryExpensesTableViewSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        if let expenses = categoriesMonthExpenses {
            for categoryMonthExpenses in expenses.categoriesMonthExpenses {
                let cellController = createMonthCategoryExpensesTableViewController(categoryMonthExpenses: categoryMonthExpenses)
                cellControllers.append(cellController)
            }
        }
        monthCategoryExpensesTableViewSectionController.cellControllers = cellControllers
        monthCategoryExpensesTableViewController.sectionControllers = [monthCategoryExpensesTableViewSectionController]
        monthCategoryExpensesTableViewController.reload()
    }
    
    private func createMonthCategoryExpensesTableViewController(categoryMonthExpenses: CategoryMonthExpenses) -> AUITableViewCellController {
        let cellController = MonthCategoryExpensesTableViewCellController(appearance: appearance, categoryMonthExpenses: categoryMonthExpenses, fundsAmountNumberFormatter: fundsAmountNumberFormatter)
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
