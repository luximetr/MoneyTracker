//
//  HistoryScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class HistoryScreenView: TitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let tableView = UITableView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        insertSubview(tableView, belowSubview: navigationBarView)
        setupTableView()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.white
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.white
    }
    
    private let dayTableViewCellReuseIdentifier = "dayTableViewCellReuseIdentifier"
    private let expenseTableViewCellReuseIdentifier = "expenseTableViewCellReuseIdentifier"
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: dayTableViewCellReuseIdentifier)
        tableView.register(AddExpenseScreenViewController.ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    // MARK: Layout
    
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
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: ExpensesTableView
    
    func dayTableViewCell(_ indexPath: IndexPath) -> DayTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dayTableViewCellReuseIdentifier, for: indexPath) as! DayTableViewCell
        return cell
    }
    
    func dayTableViewCellEstimatedHeight() -> CGFloat {
        return 34
    }
    
    func dayTableViewCellHeight() -> CGFloat {
        return 34
    }
    
    // MARK: ExpensesTableView
    
    func expenseTableViewCell(_ indexPath: IndexPath) -> AddExpenseScreenViewController.ExpenseTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expenseTableViewCellReuseIdentifier, for: indexPath) as! AddExpenseScreenViewController.ExpenseTableViewCell
        return cell
    }
    
    func expenseTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func expenseTableViewCellHeight() -> CGFloat {
        return 53
    }
    
}
}
