//
//  MonthCategoryExpensesTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthCategoryExpensesTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(categoryLabel)
        setupCategoryLabel()
        contentView.addSubview(amountLabel)
        setupAmountLabel()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Fonts.default(size: 17, weight: .regular)
        categoryLabel.textColor = Colors.primaryText
    }
    
    private func setupAmountLabel() {
        amountLabel.font = Fonts.default(size: 17, weight: .regular)
        amountLabel.textColor = Colors.primaryText
        amountLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.secondaryBackground
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCategoryLabel()
        layoutAmountLabel()
        layoutSeparatorView()
    }
    
    private func layoutCategoryLabel() {
        let x: CGFloat = 24
        let y: CGFloat = 0
        let height: CGFloat = bounds.height - 1
        let width = categoryLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        categoryLabel.frame = frame
    }
    
    private func layoutAmountLabel() {
        let x: CGFloat = categoryLabel.frame.origin.x + categoryLabel.frame.size.width + 16
        let y: CGFloat = 0
        let height: CGFloat = bounds.height - 1
        let width = bounds.width - x - 24
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountLabel.frame = frame
        amountLabel.textAlignment = .right
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 24
        let y: CGFloat = bounds.height - 1
        let height: CGFloat = 1
        let width = bounds.width - x
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
}
}
