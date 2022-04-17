//
//  HistoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit

final class HistoryScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private var expenses: [Expense]
    
    var deleteExpenseClosure: ((Expense) throws -> Void)?
    var selectExpenseClosure: ((Expense) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, expenses: [Expense]) {
        self.expenses = expenses
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: View
    
    private var screenView: HistoryScreenView! {
        return view as? HistoryScreenView
    }
    
    override func loadView() {
        view = HistoryScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.tableView = screenView.tableView
        setTableViewControllerContent()
        setContent()
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    private let expensesSectionController = AUIEmptyTableViewSectionController()
    private func dayCellControllerForDay(_ day: Date) -> AUITableViewCellController? {
        let cellController = expensesSectionController.cellControllers.first { cellController in
            guard let dayCellController = cellController as? DayTableViewCellController else { return false }
            return dayCellController.day == Calendar.current.startOfDay(for: day)
        }
        return cellController
    }
    private func expenseCellControllerForExpense(_ expense: Expense) -> AddExpenseScreenViewController.ExpenseTableViewCellController? {
        let cellController = expensesSectionController.cellControllers.first { cellController in
            guard let expenseCellController = cellController as? AddExpenseScreenViewController.ExpenseTableViewCellController else { return false }
            return expenseCellController.expense.id == expense.id
        }
        return cellController as? AddExpenseScreenViewController.ExpenseTableViewCellController
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "HistoryScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: Events
    
    func deleteExpense(_ deletingExpense: Expense) {
        if let index = expenses.firstIndex(of: deletingExpense) {
            expenses.remove(at: index)
            setTableViewControllerContent()
        }
    }
    
    func editExpense(_ editedExpense: Expense) {
        guard let index = expenses.firstIndex(where: { $0.id == editedExpense.id }) else { return }
        expenses[index] = editedExpense
        setTableViewControllerContent()
    }
    
    func insertExpense(_ expense: Expense) {
        expenses.append(expense)
        setTableViewControllerContent()
    }
    
    func insertExpenses(_ expenses: [Expense]) {
        guard !expenses.isEmpty else { return }
        self.expenses.append(contentsOf: expenses)
        setTableViewControllerContent()
    }
    
    // MARK: Content
    
    private func setTableViewControllerContent() {
        expensesSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        let daysExpenses = Dictionary(grouping: expenses) { Calendar.current.startOfDay(for: $0.date) }.sorted(by: { $0.0 > $1.0 })
        for (day, expenses) in daysExpenses {
            let dayCellController = createDayTableViewController(day: day, expenses: expenses)
            cellControllers.append(dayCellController)
            for expense in expenses {
                let expenseCellController = createExpenseTableViewController(expense: expense)
                cellControllers.append(expenseCellController)
            }
        }
        expensesSectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [expensesSectionController]
        tableViewController.reload()
    }
    
    private func createDayTableViewController(day: Date, expenses: [Expense]) -> AUITableViewCellController {
        let cellController = DayTableViewCellController(day: day, expenses: expenses)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.dayTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.dayTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.dayTableViewCellHeight()
        }
        return cellController
    }
    
    private func createExpenseTableViewController(expense: Expense) -> AUITableViewCellController {
        let cellController = AddExpenseScreenViewController.ExpenseTableViewCellController(expense: expense)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.expenseTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.expenseTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.expenseTableViewCellHeight()
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self] contextualAction, view, success in
                guard let self = self else { return }
                guard let deleteExpenseClosure = self.deleteExpenseClosure else {
                    success(false)
                    return
                }
                do {
                    try deleteExpenseClosure(expense)
                    guard let index = self.expenses.firstIndex(where: { expense == $0 }) else {
                        success(false)
                        return
                    }
                    self.expenses.remove(at: index)
                    let cellControllers: [AUITableViewCellController] = [cellController]
                    self.tableViewController.deleteCellControllersAnimated(cellControllers, .left) { finished in
                        success(true)
                    }
                } catch {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.selectExpenseClosure?(expense)
        }
        return cellController
    }
    
}
