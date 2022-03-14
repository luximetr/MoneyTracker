//
//  ExpenseTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class ExpenseTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let accountLabel = UILabel()
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let commentLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(accountLabel)
        setupAccountLabel()
        contentView.addSubview(categoryLabel)
        setupCategoryLabel()
        contentView.addSubview(amountLabel)
        setupAmountLabel()
        contentView.addSubview(commentLabel)
        setupCommentLabel()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupAccountLabel() {
        accountLabel.font = Fonts.default(size: 12, weight: .regular)
        accountLabel.textColor = Colors.secondaryText
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Fonts.default(size: 16, weight: .regular)
        categoryLabel.textColor = Colors.primaryText
    }
    
    private func setupAmountLabel() {
        amountLabel.font = Fonts.default(size: 12, weight: .semibold)
        amountLabel.textColor = Colors.primaryText
    }
    
    private func setupCommentLabel() {
        commentLabel.font = Fonts.default(size: 12, weight: .regular)
        commentLabel.textColor = Colors.secondaryText
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.secondaryBackground
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAccountLabel()
        layoutCategoryLabel()
        layoutAmountLabel()
        layoutCommentLabel()
        layoutSeparatorView()
    }
    
    private func layoutAccountLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 8
        let height: CGFloat = 20
        let width = accountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountLabel.frame = frame
    }
    
    private func layoutCategoryLabel() {
        let x: CGFloat = 16
        let y: CGFloat = accountLabel.frame.origin.y + accountLabel.frame.size.height
        let height: CGFloat = 22
        let width = categoryLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        categoryLabel.frame = frame
    }
    
    private func layoutAmountLabel() {
        let x: CGFloat = accountLabel.frame.origin.x + accountLabel.frame.size.width + 16
        let y: CGFloat = 8
        let height: CGFloat = 16
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountLabel.frame = frame
        amountLabel.textAlignment = .right
    }
    
    private func layoutCommentLabel() {
        let x: CGFloat = categoryLabel.frame.origin.x + categoryLabel.frame.size.width + 16
        let y: CGFloat = amountLabel.frame.origin.y + amountLabel.frame.size.height + 6
        let height: CGFloat = 14
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        commentLabel.frame = frame
        commentLabel.textAlignment = .right
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 16
        let y: CGFloat = bounds.height - 1
        let height: CGFloat = 1
        let width = bounds.width - x
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
}
}
