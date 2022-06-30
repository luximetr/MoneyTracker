//
//  HistoryScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit

public enum Historyitem: Hashable, Equatable {
    case day(Date, CurrenciesAmount)
    case expense(Expense)
    case transfer(Transfer)
    case replenishment(Replenishment)
}

final class HistoryScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private var historyItems: [Historyitem]?
    
    var historyItemsClosure: ((@escaping (Result<[Historyitem], Swift.Error>) -> Void) -> Void)?
    
    private func loadHistoryItems() {
        screenView.tableViewRefreshControl.beginRefreshing()
        historyItemsClosure?({ [weak self] result in
            guard let self = self else { return }
            self.screenView.tableViewRefreshControl.endRefreshing()
            switch result {
            case .success(let historyItems):
                self.historyItems = historyItems
                self.setTableViewControllerContent()
            case .failure:
                self.backClosure?()
            }
        })
    }
    
    var backClosure: (() -> Void)?
    var deleteExpenseClosure: ((Expense) throws -> Void)?
    var selectExpenseClosure: ((Expense) -> Void)?
    var deleteTransferClosure: ((Transfer) throws -> Void)?
    var selectTransferClosure: ((Transfer) -> Void)?
    var deleteReplenishmentClosure: ((Replenishment) throws -> Void)?
    var selectReplenishmentClosure: ((Replenishment) -> Void)?
    
    // MARK: View
    
    private var screenView: HistoryScreenView {
        return view as! HistoryScreenView
    }
    
    override func loadView() {
        view = HistoryScreenView(appearance: appearance)
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
    private func expenseCellController(expense: Expense) -> AUITableViewCellController? {
        let cellController = sectionController.cellControllers.first { cellController in
            if let expenseCellController = cellController as? ExpenseTableViewCellController {
                return expenseCellController.expense.id == expense.id
            } else {
                return false
            }
        }
        return cellController
    }
    private func replenishmentCellController(replenishment: Replenishment) -> AUITableViewCellController? {
        let cellController = sectionController.cellControllers.first { cellController in
            if let replenishmentCellController = cellController as? ReplenishmentTableViewCellController {
                return replenishmentCellController.replenishment.id == replenishment.id
            } else {
                return false
            }
        }
        return cellController
    }
    private func transferCellController(transfer: Transfer) -> AUITableViewCellController? {
        let cellController = sectionController.cellControllers.first { cellController in
            if let transferCellController = cellController as? TransferTableViewCellController {
                return transferCellController.transfer.id == transfer.id
            } else {
                return false
            }
        }
        return cellController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.tableViewRefreshControl.addTarget(self, action: #selector(tableViewRefreshControlValueChangedAction), for: .valueChanged)
        tableViewController.tableView = screenView.tableView
        setTableViewControllerContent()
        setContent()
        loadHistoryItems()
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.setAppearance(appearance)
    }
    
    // MARK: Localization
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "HistoryScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func tableViewRefreshControlValueChangedAction() {
        screenView.tableViewRefreshControl.endRefreshing()
    }
    
//    private func operationDeleteActionHandler(_ historyItem: Historyitem, completionHandler: @escaping ((Swift.Error?) -> Void)) {
//        do {
//            switch historyItem {
//            case .day:
//                completionHandler(nil)
//                return
//            case .expense(let expense):
//                guard let deleteExpenseClosure = self.deleteExpenseClosure else {
//                    throw Error("deleteExpenseClosure property is not set")
//                }
//                try deleteExpenseClosure(expense)
//            case .transfer(let balanceTransfer):
//                guard let deleteBalanceTransferClosure = self.deleteTransferClosure else {
//                    throw Error("deleteBalanceTransferClosure property is not set")
//                }
//                try deleteBalanceTransferClosure(balanceTransfer)
//            case .replenishment(let replenishment):
//                guard let deleteReplenishmentClosure = self.deleteBalanceReplenishmentClosure else {
//                    throw Error("deleteReplenishmentClosure property is not set")
//                }
//                try deleteReplenishmentClosure(replenishment)
//            }
//            guard let index = self.historyItems?.firstIndex(where: { $0 == historyItem }) else {
//                throw Error("Cannot find operation")
//            }
//            historyItems?.remove(at: index)
//            guard let cellController = self.operationCellController(operation: operation) else { return }
//            var cellControllers: [AUITableViewCellController] = [cellController]
//            let day = operation.timestamp
//            let operations = self.operations(day: day)
//            let dayCellController = self.dayCellController(day: day)
//            dayCellController?.setOperations(operations)
//            if self.operations(day: day).isEmpty, let dayCellController = dayCellController {
//                cellControllers.append(dayCellController)
//            }
//            self.tableViewController.deleteCellControllersAnimated(cellControllers, .left) { finished in
//                completionHandler(nil)
//            }
//        } catch {
//            completionHandler(error)
//        }
//    }
        
    private func selectExpense(_ expense: Expense) {
        self.selectExpenseClosure?(expense)
    }
    
    func editExpense(_ editedExpense: Expense) {
        loadHistoryItems()
    }
    
    private func selectReplenishment(_ replenishment: Replenishment) {
        self.selectReplenishmentClosure?(replenishment)
    }
    
    func editReplenishment(_ editedReplenishment: Replenishment) {
        loadHistoryItems()
    }
    
    private func selectTransfer(_ transfer: Transfer) {
        self.selectTransferClosure?(transfer)
    }
    
    func editTransfer(_ editedTransfer: Transfer) {
        loadHistoryItems()
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    private func setTableViewControllerContent() {
        guard let operations = historyItems else { return }
        var cellControllers: [AUITableViewCellController] = []
        for historyItem in operations {
            switch historyItem {
            case let .day(day, currenciesAmount):
                let dayTableViewController = initializeDayTableViewController(day: day, currenciesAmount: currenciesAmount)
                cellControllers.append(dayTableViewController)
            case .expense(let expense):
                let expenseCellController = initializeExpenseTableViewController(expense: expense)
                cellControllers.append(expenseCellController)
            case .transfer(let transfer):
                let transferCellController = initializeTransferTableViewController(transfer: transfer)
                cellControllers.append(transferCellController)
            case .replenishment(let replenishment):
                let replenishmentCellController = initializeReplenishmentTableViewController(replenishment: replenishment)
                cellControllers.append(replenishmentCellController)
            }
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
        tableViewController.reload()
    }
    
    private func initializeDayTableViewController(day: Date, currenciesAmount: CurrenciesAmount) -> AUITableViewCellController {
        let cellController = DayTableViewCellController(locale: locale, day: day, currenciesAmount: currenciesAmount)
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
    
    private func initializeExpenseTableViewController(expense: Expense) -> AUITableViewCellController {
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
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return nil }
            guard let cellController = cellController else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self, weak cellController] contextualAction, view, success in
                guard let self = self else { return }
                guard let cellController = cellController else { return }
                let expense = cellController.expense
                if let deleteExpenseClosure = self.deleteExpenseClosure {
                    do {
                        try deleteExpenseClosure(expense)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItems()
                        }
                    } catch {
                        success(false)
                    }
                } else {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            let expense = cellController.expense
            self.selectExpense(expense)
        }
        return cellController
    }
    
    private func initializeReplenishmentTableViewController(replenishment: Replenishment) -> AUITableViewCellController {
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
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return nil }
            guard let cellController = cellController else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self, weak cellController] contextualAction, view, success in
                guard let self = self else { return }
                guard let cellController = cellController else { return }
                let replenishment = cellController.replenishment
                if let deleteReplenishmentClosure = self.deleteReplenishmentClosure {
                    do {
                        try deleteReplenishmentClosure(replenishment)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItems()
                        }
                    } catch {
                        success(false)
                    }
                } else {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            let replenishment = cellController.replenishment
            self.selectReplenishment(replenishment)
        }
        return cellController
    }
    
    private func initializeTransferTableViewController(transfer: Transfer) -> AUITableViewCellController {
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
        cellController.trailingSwipeActionsConfigurationForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return nil }
            guard let cellController = cellController else { return nil }
            let title = self.localizer.localizeText("delete")
            let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { [weak self, weak cellController] contextualAction, view, success in
                guard let self = self else { return }
                guard let cellController = cellController else { return }
                let transfer = cellController.transfer
                if let deleteTransferClosure = self.deleteTransferClosure {
                    do {
                        try deleteTransferClosure(transfer)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItems()
                        }
                    } catch {
                        success(false)
                    }
                } else {
                    success(false)
                }
            })
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            let transfer = cellController.transfer
            self.selectTransfer(transfer)
        }
        return cellController
    }
        
}
