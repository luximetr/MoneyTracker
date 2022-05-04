//
//  HistoryScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class HistoryScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let tableView = UITableView()
    private var dayTableViewCells: [DayTableViewCell]? {
        let dayTableViewCells = tableView.visibleCells.compactMap({ $0 as? DayTableViewCell })
        return dayTableViewCells
    }
    private var expenseTableViewCells: [ExpenseTableViewCell]? {
        let expenseTableViewCells = tableView.visibleCells.compactMap({ $0 as? ExpenseTableViewCell })
        return expenseTableViewCells
    }
    private var replenishmentTableViewCells: [ReplenishmentTableViewCell]? {
        let replenishmentTableViewCells = tableView.visibleCells.compactMap({ $0 as? ReplenishmentTableViewCell })
        return replenishmentTableViewCells
    }
    private var transferTableViewCells: [TransferTableViewCell]? {
        let transferTableViewCells = tableView.visibleCells.compactMap({ $0 as? TransferTableViewCell })
        return transferTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupDayTableViewCell()
        setupExpenseTableViewCell()
        setupReplenishmentTableViewCell()
        setupTransferTableViewCell()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appearance.primaryBackground
        tableView.separatorStyle = .none
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    private let dayTableViewCellReuseIdentifier = "dayTableViewCellReuseIdentifier"
    private func setupDayTableViewCell() {
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: dayTableViewCellReuseIdentifier)
    }
    
    private let expenseTableViewCellReuseIdentifier = "expenseTableViewCellReuseIdentifier"
    private func setupExpenseTableViewCell() {
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    private let replenishmentTableViewCellReuseIdentifier = "replenishmentTableViewCellReuseIdentifier"
    private func setupReplenishmentTableViewCell() {
        tableView.register(ReplenishmentTableViewCell.self, forCellReuseIdentifier: replenishmentTableViewCellReuseIdentifier)
    }
    
    private let transferTableViewCellReuseIdentifier = "transferTableViewCellReuseIdentifier"
    private func setupTransferTableViewCell() {
        tableView.register(TransferTableViewCell.self, forCellReuseIdentifier: transferTableViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableView()
    }
    
    private func layoutTableView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        tableView.frame = frame
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - DayTableViewCell
    
    func dayTableViewCell(_ indexPath: IndexPath) -> DayTableViewCell {
        let dayTableViewCell = tableView.dequeueReusableCell(withIdentifier: dayTableViewCellReuseIdentifier, for: indexPath) as! DayTableViewCell
        dayTableViewCell.setAppearance(appearance)
        return dayTableViewCell
    }
    
    func dayTableViewCellEstimatedHeight() -> CGFloat {
        return 34
    }
    
    func dayTableViewCellHeight() -> CGFloat {
        return 34
    }
    
    // MARK: - ExpensesTableViewCell
    
    func expenseTableViewCell(_ indexPath: IndexPath) -> ExpenseTableViewCell {
        let expenseTableViewCell = tableView.dequeueReusableCell(withIdentifier: expenseTableViewCellReuseIdentifier, for: indexPath) as! ExpenseTableViewCell
        expenseTableViewCell.setAppearance(appearance)
        return expenseTableViewCell
    }
    
    func expenseTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func expenseTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - ReplenishmentTableViewCell
    
    func replenishmentTableViewCell(_ indexPath: IndexPath) -> ReplenishmentTableViewCell {
        let replenishmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: replenishmentTableViewCellReuseIdentifier, for: indexPath) as! ReplenishmentTableViewCell
        replenishmentTableViewCell.setAppearance(appearance)
        return replenishmentTableViewCell
    }
    
    func replenishmentTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func replenishmentTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - BalanceTransferTableViewCell
    
    func transferTableViewCell(_ indexPath: IndexPath) -> TransferTableViewCell {
        let transferTableViewCell = tableView.dequeueReusableCell(withIdentifier: transferTableViewCellReuseIdentifier, for: indexPath) as! TransferTableViewCell
        transferTableViewCell.setAppearance(appearance)
        return transferTableViewCell
    }
    
    func transferTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func transferTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
        dayTableViewCells?.forEach({ $0.setAppearance(appearance) })
        expenseTableViewCells?.forEach({ $0.setAppearance(appearance) })
        replenishmentTableViewCells?.forEach({ $0.setAppearance(appearance) })
        transferTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
}
}
