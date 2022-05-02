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
    private var balanceReplenishmentTableViewCells: [BalanceReplenishmentTableViewCell]? {
        let balanceReplenishmentTableViewCells = tableView.visibleCells.compactMap({ $0 as? BalanceReplenishmentTableViewCell })
        return balanceReplenishmentTableViewCells
    }
    private var balanceTransferTableViewCells: [BalanceTransferTableViewCell]? {
        let balanceTransferTableViewCells = tableView.visibleCells.compactMap({ $0 as? BalanceTransferTableViewCell })
        return balanceTransferTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupDayTableViewCell()
        setupExpenseTableViewCell()
        setupBalanceReplenishmentTableViewCell()
        setupBalanceTransferTableViewCell()
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
    
    private let balanceReplenishmentTableViewCellReuseIdentifier = "balanceReplenishmentTableViewCellReuseIdentifier"
    private func setupBalanceReplenishmentTableViewCell() {
        tableView.register(BalanceReplenishmentTableViewCell.self, forCellReuseIdentifier: balanceReplenishmentTableViewCellReuseIdentifier)
    }
    
    private let balanceTransferTableViewCellReuseIdentifier = "balanceTransferTableViewCellReuseIdentifier"
    private func setupBalanceTransferTableViewCell() {
        tableView.register(BalanceTransferTableViewCell.self, forCellReuseIdentifier: balanceTransferTableViewCellReuseIdentifier)
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
    
    // MARK: - BalanceReplenishmentTableViewCell
    
    func balanceReplenishmentTableViewCell(_ indexPath: IndexPath) -> BalanceReplenishmentTableViewCell {
        let balanceReplenishmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: balanceReplenishmentTableViewCellReuseIdentifier, for: indexPath) as! BalanceReplenishmentTableViewCell
        balanceReplenishmentTableViewCell.setAppearance(appearance)
        return balanceReplenishmentTableViewCell
    }
    
    func balanceReplenishmentTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func balanceReplenishmentTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - BalanceTransferTableViewCell
    
    func balanceTransferTableViewCell(_ indexPath: IndexPath) -> BalanceTransferTableViewCell {
        let balanceTransferTableViewCell = tableView.dequeueReusableCell(withIdentifier: balanceTransferTableViewCellReuseIdentifier, for: indexPath) as! BalanceTransferTableViewCell
        balanceTransferTableViewCell.setAppearance(appearance)
        return balanceTransferTableViewCell
    }
    
    func balanceTransferTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func balanceTransferTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
        dayTableViewCells?.forEach({ $0.setAppearance(appearance) })
        expenseTableViewCells?.forEach({ $0.setAppearance(appearance) })
        balanceReplenishmentTableViewCells?.forEach({ $0.setAppearance(appearance) })
        balanceTransferTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
}
}
