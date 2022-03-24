//
//  StatisticScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import UIKit
import AUIKit
import PinLayout

extension StatisticScreenViewController {
final class ScreenView: TitleNavigationBarScreenView {
    
    // MARK: - UI elements
    
    let monthPickerView = UIView()
    let monthExpensesLabel = UILabel()
    let monthCategoriesExpensesTableView = UITableView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        addSubview(monthPickerView)
        addSubview(monthExpensesLabel)
        setupMonthExpensesLabel()
        addSubview(monthCategoriesExpensesTableView)
        setupMonthCategoriesExpensesTableView()
    }
    
    private func setupMonthExpensesLabel() {
        monthExpensesLabel.font = Fonts.default(size: 24, weight: .medium)
        monthExpensesLabel.textColor = Colors.primaryText
        monthExpensesLabel.adjustsFontSizeToFitWidth = true
    }
    
    private let monthCategoriesExpensesTableViewCellReuseIdentifier = "monthCategoriesExpensesTableViewCellReuseIdentifier"
    private func setupMonthCategoriesExpensesTableView() {
        monthCategoriesExpensesTableView.separatorStyle = .none
        monthCategoriesExpensesTableView.register(MonthCategoryExpensesTableViewCell.self, forCellReuseIdentifier: monthCategoriesExpensesTableViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMonthPickerView()
        layoutMonthExpensesLabel()
        layoutMonthCategoriesExpensesTableView()
    }
    
    private func layoutMonthPickerView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height: CGFloat = 64
        let frame = CGRect(x: x, y: y, width: width, height: height)
        monthPickerView.frame = frame
    }
    
    private func layoutMonthExpensesLabel() {
        let x: CGFloat = 24
        let y = monthPickerView.frame.origin.y + monthPickerView.frame.size.height + 48
        let width = bounds.width - 2 * x
        let height = monthExpensesLabel.sizeThatFits(CGSize(width: width, height: bounds.height)).height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        monthExpensesLabel.frame = frame
    }
    
    private func layoutMonthCategoriesExpensesTableView() {
        let x: CGFloat = 0
        let y = monthExpensesLabel.frame.origin.y + monthExpensesLabel.frame.size.height + 48
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        monthCategoriesExpensesTableView.frame = frame
    }
    
    // MARK: ExpensesTableView
    
    func monthCategoryExpensesTableViewCell(_ indexPath: IndexPath) -> MonthCategoryExpensesTableViewCell {
        let cell = monthCategoriesExpensesTableView.dequeueReusableCell(withIdentifier: monthCategoriesExpensesTableViewCellReuseIdentifier, for: indexPath) as! MonthCategoryExpensesTableViewCell
        return cell
    }
    
    func monthCategoryExpensesTableViewCellEstimatedHeight() -> CGFloat {
        return 49
    }
    
    func monthCategoryExpensesTableViewCellHeight() -> CGFloat {
        return 49
    }
    
}
}
