//
//  MonthTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.03.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class DayTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let dayLabel = UILabel()
    let expensesLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(dayLabel)
        setupDayLabel()
        contentView.addSubview(expensesLabel)
        setupExpensesLabel()
    }
    
    private func setupDayLabel() {
        dayLabel.font = Fonts.default(size: 10, weight: .regular)
        dayLabel.textColor = Colors.secondaryText
    }
    
    private func setupExpensesLabel() {
        expensesLabel.font = Fonts.default(size: 10, weight: .regular)
        expensesLabel.textColor = Colors.secondaryText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutDayLabel()
        layoutExpensesLabel()
    }
    
    private func layoutDayLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 4
        let height = bounds.height - y
        let possibleWidth = bounds.width - x
        let width = dayLabel.sizeThatFits(CGSize(width: possibleWidth, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        dayLabel.frame = frame
    }
    
    private func layoutExpensesLabel() {
        let x = dayLabel.frame.origin.x + dayLabel.frame.size.width + 16
        let y: CGFloat = 4
        let height = bounds.height - y
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        expensesLabel.frame = frame
        expensesLabel.textAlignment = .right
    }
    
}
}
