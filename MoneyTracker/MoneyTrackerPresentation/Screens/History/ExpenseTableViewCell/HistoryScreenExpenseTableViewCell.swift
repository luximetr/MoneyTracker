//
//  ExpenseTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class ExpenseTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let accountLabel = UILabel()
    let amountLabel = UILabel()
    let balanceTransferImageView = UIImageView()
    let categoryLabel = UILabel()
    let commentLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(accountLabel)
        setupAccountLabel()
        contentView.addSubview(amountLabel)
        setupAmountLabel()
        contentView.addSubview(balanceTransferImageView)
        setupBalanceTransferImageView()
        contentView.addSubview(categoryLabel)
        setupCategoryLabel()
        contentView.addSubview(commentLabel)
        setupCommentLabel()
        contentView.addSubview(separatorView)
    }
    
    private func setupAccountLabel() {
        accountLabel.font = Fonts.default(size: 12, weight: .regular)
    }
    
    private func setupAmountLabel() {
        amountLabel.font = Fonts.default(size: 12, weight: .semibold)
    }
    
    private func setupBalanceTransferImageView() {
        balanceTransferImageView.contentMode = .scaleAspectFit
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Fonts.default(size: 12, weight: .regular)
    }
    
    private func setupCommentLabel() {
        commentLabel.font = Fonts.default(size: 12, weight: .regular)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAccountLabel()
        layoutAmountLabel()
        layoutBalanceTransferImageView()
        layoutCategoryLabel()
        layoutCommentLabel()
        layoutSeparatorView()
    }
    
    private func layoutAccountLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = accountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountLabel.frame = frame
    }
    
    private func layoutAmountLabel() {
        let x: CGFloat = accountLabel.frame.origin.x + accountLabel.frame.size.width + 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountLabel.frame = frame
        amountLabel.textAlignment = .right
    }
    
    private func layoutBalanceTransferImageView() {
        let x: CGFloat = 16
        let y: CGFloat = accountLabel.frame.maxY + 4
        let height: CGFloat = 12
        let width: CGFloat = 12
        let frame = CGRect(x: x, y: y, width: width, height: height)
        balanceTransferImageView.frame = frame
    }
    
    private func layoutCategoryLabel() {
        let x: CGFloat = balanceTransferImageView.frame.maxX + 4
        let y: CGFloat = accountLabel.frame.origin.y + accountLabel.frame.size.height
        let height: CGFloat = 20
        let width = categoryLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        categoryLabel.frame = frame
    }
    
    private func layoutCommentLabel() {
        let x: CGFloat = categoryLabel.frame.origin.x + categoryLabel.frame.size.width + 16
        let y: CGFloat = amountLabel.frame.origin.y + amountLabel.frame.size.height
        let height: CGFloat = 20
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        accountLabel.textColor = appearance.secondaryText
        amountLabel.textColor = appearance.primaryText
        balanceTransferImageView.tintColor = appearance.primaryText
        categoryLabel.textColor = appearance.primaryText
        commentLabel.textColor = appearance.secondaryText
        separatorView.backgroundColor = appearance.secondaryBackground
    }
    
}
}
