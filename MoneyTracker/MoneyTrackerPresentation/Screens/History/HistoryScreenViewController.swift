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
    
    private var historyItems: [Historyitem]?
    
    // MARK: Actions
    
    var back: (() -> Void)?
    
    var loadHistoryItems: ((@escaping (Result<[Historyitem]?, Swift.Error>) -> Void) -> Void)?
    
    private func loadHistoryItemsSettingContent() {
        guard let loadHistoryItems = loadHistoryItems else { return }
        loadHistoryItems({ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let historyItems):
                self.historyItems = historyItems
                self.setTableViewControllerContent()
            case .failure:
                self.back?()
            }
        })
    }
    
    var deleteExpense: ((Expense) throws -> Void)?
    
    var selectExpense: ((Expense) -> Void)?
    
    var deleteTransfer: ((Transfer) throws -> Void)?
    
    var selectTransfer: ((Transfer) -> Void)?
    
    var deleteReplenishment: ((Replenishment) throws -> Void)?
    
    var selectReplenishment: ((Replenishment) -> Void)?
    
    func editExpense(_ editedExpense: Expense) {
        loadHistoryItemsSettingContent()
    }
    
    func editReplenishment(_ editedReplenishment: Replenishment) {
        loadHistoryItemsSettingContent()
    }
    
    func editTransfer(_ editedTransfer: Transfer) {
        loadHistoryItemsSettingContent()
    }
    
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
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideAction), for: .touchUpInside)
        screenView.tableViewRefreshControl.addTarget(self, action: #selector(tableViewRefreshControlValueChangedAction), for: .valueChanged)
        tableViewController.tableView = screenView.tableView
        setTableViewControllerContent()
        setContent()
        loadHistoryItemsSettingContent()
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
    
    @objc private func backButtonTouchUpInsideAction() {
        guard let back = back else { return }
        back()
    }
    
    @objc private func tableViewRefreshControlValueChangedAction() {
        guard let loadHistoryItems = loadHistoryItems else { return }
        loadHistoryItems({ [weak self] result in
            guard let self = self else { return }
            self.screenView.tableViewRefreshControl.endRefreshing()
            switch result {
            case .success(let historyItems):
                self.historyItems = historyItems
                self.setTableViewControllerContent()
            case .failure:
                self.back?()
            }
        })
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
                let dayTableViewController = initializeDayCellController(day: day, currenciesAmount: currenciesAmount)
                cellControllers.append(dayTableViewController)
            case .expense(let expense):
                let expenseCellController = initializeExpenseCellController(expense: expense)
                cellControllers.append(expenseCellController)
            case .transfer(let transfer):
                let transferCellController = initializeTransferCellController(transfer: transfer)
                cellControllers.append(transferCellController)
            case .replenishment(let replenishment):
                let replenishmentCellController = initializeReplenishmentCellController(replenishment: replenishment)
                cellControllers.append(replenishmentCellController)
            }
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
        tableViewController.reload()
    }
    
    private func initializeDayCellController(day: Date, currenciesAmount: CurrenciesAmount) -> AUITableViewCellController {
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
    
    private func initializeExpenseCellController(expense: Expense) -> AUITableViewCellController {
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
                if let deleteExpenseClosure = self.deleteExpense {
                    do {
                        try deleteExpenseClosure(expense)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItemsSettingContent()
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
            guard let selectExpense = self.selectExpense else { return }
            selectExpense(expense)
        }
        return cellController
    }
    
    private func initializeReplenishmentCellController(replenishment: Replenishment) -> AUITableViewCellController {
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
                if let deleteReplenishmentClosure = self.deleteReplenishment {
                    do {
                        try deleteReplenishmentClosure(replenishment)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItemsSettingContent()
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
            guard let selectReplenishment = self.selectReplenishment else { return }
            let replenishment = cellController.replenishment
            selectReplenishment(replenishment)
        }
        return cellController
    }
    
    private func initializeTransferCellController(transfer: Transfer) -> AUITableViewCellController {
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
                if let deleteTransferClosure = self.deleteTransfer {
                    do {
                        try deleteTransferClosure(transfer)
                        self.tableViewController.deleteCellControllerAnimated(cellController, .left) { [weak self] finished in
                            guard let self = self else { return }
                            success(true)
                            self.loadHistoryItemsSettingContent()
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
            guard let selectTransfer = self.selectTransfer else { return }
            let transfer = cellController.transfer
            selectTransfer(transfer)
        }
        return cellController
    }
        
}
