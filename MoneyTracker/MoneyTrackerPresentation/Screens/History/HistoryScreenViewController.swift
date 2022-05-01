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
    
    private var operations: [Operation]
    func operations(_ day: Date) -> [Operation] {
        let operations = self.operations.filter({ Calendar.current.isDate($0.timestamp, inSameDayAs: day) })
        return operations
    }
    
    var backClosure: (() -> Void)?
    var deleteExpenseClosure: ((Expense) throws -> Void)?
    var selectExpenseClosure: ((Expense) -> Void)?
    var deleteBalanceTransferClosure: ((BalanceTransfer) throws -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, operations: [Operation]) {
        self.operations = operations
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: View
    
    private var screenView: HistoryScreenView! {
        return view as? HistoryScreenView
    }
    
    override func loadView() {
        view = HistoryScreenView(appearance: appearance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
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
    private func expenseCellControllerForExpense(_ expense: Expense) -> ExpenseTableViewCellController? {
        let cellController = expensesSectionController.cellControllers.first { cellController in
            guard let expenseCellController = cellController as? ExpenseTableViewCellController else { return false }
            return expenseCellController.expense.id == expense.id
        }
        return cellController as? ExpenseTableViewCellController
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    func editExpense(_ editedExpense: Expense) {
        guard let firstIndex = operations.firstIndex(where: { operation in
            if case let .expense(expense) = operation {
                return expense.id == editedExpense.id
            }
            return false
        }) else {
            return
        }
        operations[firstIndex] = .expense(editedExpense)
        setTableViewControllerContent()
    }
    
    // MARK: Content
    
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
    
    private func setTableViewControllerContent() {
        expensesSectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        let daysExpenses = Dictionary(grouping: operations) { Calendar.current.startOfDay(for: $0.timestamp) }.sorted(by: { $0.0 > $1.0 })
        for (day, operations) in daysExpenses {
            let dayCellController = createDayTableViewController(day: day, expenses: [])
            cellControllers.append(dayCellController)
            for opeation in operations {
                switch opeation {
                case .expense(let expense):
                    let expenseCellController = createExpenseTableViewController(expense: expense)
                    cellControllers.append(expenseCellController)
                case .balanceTransfer(let balanceTransfer):
                    let balanceTransferCellController = createBalanceTransferTableViewController(balanceTransfer: balanceTransfer)
                    cellControllers.append(balanceTransferCellController)
                case .balanceReplenishment(let balanceReplenishment):
                    let balanceReplenishmentCellController = createBalanceReplenishmentTableViewController(balanceReplenishment: balanceReplenishment)
                    cellControllers.append(balanceReplenishmentCellController)
                }
            }
        }
        expensesSectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [expensesSectionController]
        tableViewController.reload()
    }
    
    private func createDayTableViewController(day: Date, expenses: [Expense]) -> AUITableViewCellController {
        let cellController = DayTableViewCellController(language: language, day: day, expenses: expenses)
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
        let cellController = ExpenseTableViewCellController(expense: expense)
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
                let expense = cellController.expense
                do {
                    guard let self = self else { return }
                    guard let deleteExpenseClosure = self.deleteExpenseClosure else {
                        success(false)
                        return
                    }
                    try deleteExpenseClosure(expense)
                    guard let firstIndex = self.operations.firstIndex(where: { $0.id == expense.id }) else {
                        success(false)
                        return
                    }
                    self.operations.remove(at: firstIndex)
                    var cellControllers: [AUITableViewCellController] = [cellController]
                    let day = expense.date
                    if self.operations(day).isEmpty, let dayCellController = self.dayCellControllerForDay(day) {
                        cellControllers.append(dayCellController)
                    }
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
    
    private func createBalanceReplenishmentTableViewController(balanceReplenishment: BalanceReplenishment) -> AUITableViewCellController {
        let cellController = BalanceReplenishmentTableViewCellController(language: language, balanceReplenishment: balanceReplenishment)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.balanceReplenishmentTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.balanceReplenishmentTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.balanceReplenishmentTableViewCellHeight()
        }
        return cellController
    }
    
    private func createBalanceTransferTableViewController(balanceTransfer: BalanceTransfer) -> AUITableViewCellController {
        let cellController = BalanceTransferTableViewCellController(language: language, balanceTransfer: balanceTransfer)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.balanceTransferTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.balanceTransferTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.balanceTransferTableViewCellHeight()
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self] contextualAction, view, success in
                let balanceTransfer = cellController.balanceTransfer
                do {
                    guard let self = self else { return }
                    guard let deleteBalanceTransferClosure = self.deleteBalanceTransferClosure else {
                        success(false)
                        return
                    }
                    try deleteBalanceTransferClosure(balanceTransfer)
                    guard let firstIndex = self.operations.firstIndex(where: { $0.id == balanceTransfer.id }) else {
                        success(false)
                        return
                    }
                    self.operations.remove(at: firstIndex)
                    var cellControllers: [AUITableViewCellController] = [cellController]
                    let day = balanceTransfer.day
                    if self.operations(day).isEmpty, let dayCellController = self.dayCellControllerForDay(day) {
                        cellControllers.append(dayCellController)
                    }
                    self.tableViewController.deleteCellControllersAnimated(cellControllers, .left) { finished in
                        success(true)
                    }
                } catch {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return cellController
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
}
