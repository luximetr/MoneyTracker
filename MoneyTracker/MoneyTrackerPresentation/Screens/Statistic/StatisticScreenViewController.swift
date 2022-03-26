//
//  StatisticScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit

final class StatisticScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    private var expenses: [Expense] = []
    
    var monthsClosure: (() -> [Date])?
    var expensesClosure: ((Date) -> [Expense])?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "StatisticScreenStrings")
        return localizer
    }()
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
    
    override func loadView() {
        view = ScreenView()
    }
    
    private let monthPickerViewConroller = MonthPickerViewController()
    private let monthCategoryExpensesTableViewController = AUIEmptyTableViewController()
    private let monthCategoryExpensesTableViewSectionController = AUIEmptyTableViewSectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.titleLabel.text = localizer.localizeText("title")
        expenses = expensesClosure?(Date()) ?? []
        monthCategoryExpensesTableViewController.tableView = screenView.monthCategoriesExpensesTableView
        setMonthCategoryExpensesTableViewControllerContent()
        setMonthExpensesLabelContent()
        monthPickerViewConroller.monthPickerView = screenView.monthPickerView
        let months = monthsClosure?() ?? []
        monthPickerViewConroller.months = months
        if let month = months.first {
            monthPickerViewConroller.selectMonth(month, animated: false)
        }
        monthPickerViewConroller.didSelectMonthClosure = { [weak self] month in
            guard let self = self else { return }
            self.didSelectMonth(month)
        }
    }
    
    private func didSelectMonth(_ month: Date) {
        expenses = expensesClosure?(month) ?? []
        setMonthExpensesLabelContent()
        setMonthCategoryExpensesTableViewControllerContent()
    }
    
    private func setMonthCategoryExpensesTableViewControllerContent() {
        monthCategoryExpensesTableViewSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        let ggg = Dictionary(grouping: expenses) { $0.category }
        let categoriesExpenses = ggg.values.sorted(by: { $0.first?.category.name ?? "" < $1.first?.category.name ?? "" })
        for categoryExpenses in categoriesExpenses {
            let cellController = createMonthCategoryExpensesTableViewController(expenses: categoryExpenses)
            cellControllers.append(cellController)
        }
        monthCategoryExpensesTableViewSectionController.cellControllers = cellControllers
        monthCategoryExpensesTableViewController.sectionControllers = [monthCategoryExpensesTableViewSectionController]
        monthCategoryExpensesTableViewController.reload()
    }
    
    private func createMonthCategoryExpensesTableViewController(expenses: [Expense]) -> AUITableViewCellController {
        let cellController = MonthCategoryExpensesTableViewCellController(expenses: expenses)
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
    
    private func setMonthExpensesLabelContent() {
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
        screenView.monthExpensesLabel.text = currenciesAmountsStringsJoined
    }
    
}
