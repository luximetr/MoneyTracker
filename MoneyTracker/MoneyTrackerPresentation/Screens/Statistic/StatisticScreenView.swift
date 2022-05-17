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
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.monthPickerView = MonthPickerView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let monthPickerView: MonthPickerView
    let monthExpensesLabel = UILabel()
    let monthCategoriesExpensesTableView = UITableView()
    private var monthCategoryExpensesTableViewCells: [MonthCategoryExpensesTableViewCell]? {
        let monthCategoryExpensesTableViewCells = monthCategoriesExpensesTableView.visibleCells.compactMap({ $0 as? MonthCategoryExpensesTableViewCell })
        return monthCategoryExpensesTableViewCells
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        addSubview(monthPickerView)
        addSubview(monthExpensesLabel)
        setupMonthExpensesLabel()
        addSubview(monthCategoriesExpensesTableView)
        setupMonthCategoriesExpensesTableView()
        setupMonthCategoryExpensesTableViewCell()
    }
    
    private func setupMonthExpensesLabel() {
        monthExpensesLabel.font = appearance.fonts.primary(size: 24, weight: .medium)
        monthExpensesLabel.textColor = appearance.primaryText
        monthExpensesLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupMonthCategoriesExpensesTableView() {
        monthCategoriesExpensesTableView.backgroundColor = appearance.primaryBackground
        monthCategoriesExpensesTableView.separatorStyle = .none
    }
    
    private let monthCategoriesExpensesTableViewCellReuseIdentifier = "monthCategoriesExpensesTableViewCellReuseIdentifier"
    private func setupMonthCategoryExpensesTableViewCell() {
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
        let height: CGFloat = 28
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
        monthExpensesLabel.textAlignment = .center
    }
    
    private func layoutMonthCategoriesExpensesTableView() {
        let x: CGFloat = 0
        let y = monthExpensesLabel.frame.origin.y + monthExpensesLabel.frame.size.height + 48
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        monthCategoriesExpensesTableView.frame = frame
        monthCategoriesExpensesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    // MARK: - MonthCategoryExpensesTableViewCell
    
    func monthCategoryExpensesTableViewCell(_ indexPath: IndexPath) -> MonthCategoryExpensesTableViewCell {
        let monthCategoryExpensesTableViewCell = monthCategoriesExpensesTableView.dequeueReusableCell(withIdentifier: monthCategoriesExpensesTableViewCellReuseIdentifier, for: indexPath) as! MonthCategoryExpensesTableViewCell
        monthCategoryExpensesTableViewCell.setAppearance(appearance)
        return monthCategoryExpensesTableViewCell
    }
    
    func monthCategoryExpensesTableViewCellEstimatedHeight() -> CGFloat {
        return 60
    }
    
    func monthCategoryExpensesTableViewCellHeight() -> CGFloat {
        return 60
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        monthPickerView.changeAppearance(appearance)
        monthExpensesLabel.textColor = appearance.primaryText
        monthCategoriesExpensesTableView.backgroundColor = appearance.primaryBackground
        monthCategoryExpensesTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
}
}
