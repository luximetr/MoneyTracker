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
    private var expenseTableViewCells: [AddExpenseScreenViewController.ExpenseTableViewCell]? {
        let expenseTableViewCells = tableView.visibleCells.compactMap({ $0 as? AddExpenseScreenViewController.ExpenseTableViewCell })
        return expenseTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
        setupDayTableViewCell()
        setupAddExpenseScreenViewController()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appearance.primaryBackground
        tableView.separatorStyle = .none
        tableView.register(AddExpenseScreenViewController.ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    private let dayTableViewCellReuseIdentifier = "dayTableViewCellReuseIdentifier"
    private func setupDayTableViewCell() {
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: dayTableViewCellReuseIdentifier)
    }
    
    private let expenseTableViewCellReuseIdentifier = "expenseTableViewCellReuseIdentifier"
    private func setupAddExpenseScreenViewController() {
        tableView.register(AddExpenseScreenViewController.ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
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
    
    func expenseTableViewCell(_ indexPath: IndexPath) -> AddExpenseScreenViewController.ExpenseTableViewCell {
        let expenseTableViewCell = tableView.dequeueReusableCell(withIdentifier: expenseTableViewCellReuseIdentifier, for: indexPath) as! AddExpenseScreenViewController.ExpenseTableViewCell
        expenseTableViewCell.setAppearance(appearance)
        return expenseTableViewCell
    }
    
    func expenseTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func expenseTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        tableView.backgroundColor = appearance.primaryBackground
        dayTableViewCells?.forEach({ $0.setAppearance(appearance) })
        expenseTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
}
}
