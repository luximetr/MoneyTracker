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
    func operations(day: Date) -> [Operation] {
        let operations = self.operations.filter({ Calendar.current.isDate($0.timestamp, inSameDayAs: day) })
        return operations
    }
    
    var backClosure: (() -> Void)?
    var deleteExpenseClosure: ((Expense) throws -> Void)?
    var selectExpenseClosure: ((Expense) -> Void)?
    var deleteTransferClosure: ((Transfer) throws -> Void)?
    var selectTransferClosure: ((Transfer) -> Void)?
    var deleteBalanceReplenishmentClosure: ((Replenishment) throws -> Void)?
    var selectReplenishmentClosure: ((Replenishment) -> Void)?
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, operations: [Operation]) {
        self.operations = operations
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: View
    
    private var screenView: HistoryScreenView {
        return view as! HistoryScreenView
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
    private let sectionController = AUIEmptyTableViewSectionController()
    private func dayCellController(day: Date) -> DayTableViewCellController? {
        let cellController = sectionController.cellControllers.first { cellController in
            guard let dayCellController = cellController as? DayTableViewCellController else { return false }
            return dayCellController.day == Calendar.current.startOfDay(for: day)
        }
        return cellController as? DayTableViewCellController
    }
    private func operationCellController(operation: Operation) -> AUITableViewCellController? {
        let cellController = sectionController.cellControllers.first { cellController in
            if let expenseCellController = cellController as? ExpenseTableViewCellController {
                return expenseCellController.expense.id == operation.id
            } else if let balanceReplenishmentCellController = cellController as? ReplenishmentTableViewCellController {
                return balanceReplenishmentCellController.replenishment.id == operation.id
            } else if let balanceTransferCellController = cellController as? TransferTableViewCellController {
                return balanceTransferCellController.transfer.id == operation.id
            } else {
                return false
            }
        }
        return cellController
    }
    
    // MARK: Events
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
    }
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        setContent()
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func operationDeleteActionHandler(_ operation: Operation, completionHandler: @escaping ((Swift.Error?) -> Void)) {
        do {
            switch operation {
            case .expense(let expense):
                guard let deleteExpenseClosure = self.deleteExpenseClosure else {
                    throw Error("deleteExpenseClosure property is not set")
                }
                try deleteExpenseClosure(expense)
            case .transfer(let balanceTransfer):
                guard let deleteBalanceTransferClosure = self.deleteTransferClosure else {
                    throw Error("deleteBalanceTransferClosure property is not set")
                }
                try deleteBalanceTransferClosure(balanceTransfer)
            case .replenishment(let replenishment):
                guard let deleteReplenishmentClosure = self.deleteBalanceReplenishmentClosure else {
                    throw Error("deleteReplenishmentClosure property is not set")
                }
                try deleteReplenishmentClosure(replenishment)
            }
            guard let index = self.operations.firstIndex(where: { $0.id == operation.id }) else {
                throw Error("Cannot find operation")
            }
            self.operations.remove(at: index)
            guard let cellController = self.operationCellController(operation: operation) else { return }
            var cellControllers: [AUITableViewCellController] = [cellController]
            let day = operation.timestamp
            let operations = self.operations(day: day)
            let dayCellController = self.dayCellController(day: day)
            dayCellController?.setOperations(operations)
            if self.operations(day: day).isEmpty, let dayCellController = dayCellController {
                cellControllers.append(dayCellController)
            }
            self.tableViewController.deleteCellControllersAnimated(cellControllers, .left) { finished in
                completionHandler(nil)
            }
        } catch {
            completionHandler(error)
        }
    }
    
    private func selectExpense(_ expense: Expense) {
        self.selectExpenseClosure?(expense)
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
        self.operations[firstIndex] = .expense(editedExpense)
        self.operations.sort(by: { $0.timestamp > $1.timestamp })
        setTableViewControllerContent()
    }
    
    private func selectReplenishment(_ replenishment: Replenishment) {
        self.selectReplenishmentClosure?(replenishment)
    }
    
    func editReplenishment(_ editedReplenishment: Replenishment) {
        guard let firstIndex = operations.firstIndex(where: { operation in
            if case let .replenishment(replenishment) = operation {
                return replenishment.id == editedReplenishment.id
            }
            return false
        }) else {
            return
        }
        self.operations[firstIndex] = .replenishment(editedReplenishment)
        self.operations.sort(by: { $0.timestamp > $1.timestamp })
        setTableViewControllerContent()
    }
    
    private func selectTransfer(_ transfer: Transfer) {
        self.selectTransferClosure?(transfer)
    }
    
    func editTransfer(_ editedTransfer: Transfer) {
        guard let firstIndex = operations.firstIndex(where: { operation in
            if case let .transfer(transfer) = operation {
                return transfer.id == editedTransfer.id
            }
            return false
        }) else {
            return
        }
        self.operations[firstIndex] = .transfer(editedTransfer)
        self.operations.sort(by: { $0.timestamp > $1.timestamp })
        setTableViewControllerContent()
    }
    
    // MARK: Content
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: locale.language, stringsTableName: "HistoryScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    private func setTableViewControllerContent() {
        sectionController.cellControllers = []
        var cellControllers: [AUITableViewCellController] = []
        let daysExpenses = Dictionary(grouping: operations) { Calendar.current.startOfDay(for: $0.timestamp) }.sorted(by: { $0.0 > $1.0 })
        for (day, operations) in daysExpenses {
            let dayCellController = createDayTableViewController(day: day, operations: operations)
            cellControllers.append(dayCellController)
            for opeation in operations {
                switch opeation {
                case .expense(let expense):
                    let expenseCellController = createExpenseTableViewController(expense: expense)
                    cellControllers.append(expenseCellController)
                case .transfer(let transfer):
                    let transferCellController = createTransferTableViewController(transfer: transfer)
                    cellControllers.append(transferCellController)
                case .replenishment(let replenishment):
                    let replenishmentCellController = createReplenishmentTableViewController(replenishment: replenishment)
                    cellControllers.append(replenishmentCellController)
                }
            }
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
        tableViewController.reload()
    }
    
    private func createDayTableViewController(day: Date, operations: [Operation]) -> AUITableViewCellController {
        let cellController = DayTableViewCellController(locale: locale, day: day, operations: operations)
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
                guard let self = self else { return }
                let expense = cellController.expense
                let operation = Operation.expense(expense)
                self.operationDeleteActionHandler(operation) { error in
                    if error != nil {
                        success(false)
                    } else {
                        success(true)
                    }
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            let expense = cellController.expense
            self.selectExpense(expense)
        }
        return cellController
    }
    
    private func createReplenishmentTableViewController(replenishment: Replenishment) -> AUITableViewCellController {
        let cellController = ReplenishmentTableViewCellController(locale: locale, replenishment: replenishment)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.replenishmentTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.replenishmentTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.replenishmentTableViewCellHeight()
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self] contextualAction, view, success in
                guard let self = self else { return }
                let balanceReplenishment = cellController.replenishment
                let operation = Operation.replenishment(balanceReplenishment)
                self.operationDeleteActionHandler(operation) { error in
                    if error != nil {
                        success(false)
                    } else {
                        success(true)
                    }
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            let replenishment = cellController.replenishment
            self.selectReplenishment(replenishment)
        }
        return cellController
    }
    
    private func createTransferTableViewController(transfer: Transfer) -> AUITableViewCellController {
        let cellController = TransferTableViewCellController(locale: locale, transfer: transfer)
        cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UITableViewCell() }
            let cell = self.screenView.transferTableViewCell(indexPath)
            return cell
        }
        cellController.estimatedHeightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.transferTableViewCellEstimatedHeight()
        }
        cellController.heightClosure = { [weak self] in
            guard let self = self else { return 0 }
            return self.screenView.transferTableViewCellHeight()
        }
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self] in
            guard let self = self else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self] contextualAction, view, success in
                guard let self = self else { return }
                let balanceTransfer = cellController.transfer
                let operation = Operation.transfer(balanceTransfer)
                self.operationDeleteActionHandler(operation) { error in
                    if error != nil {
                        success(false)
                    } else {
                        success(true)
                    }
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            let transfer = cellController.transfer
            self.selectTransfer(transfer)
        }
        return cellController
    }
    
}
