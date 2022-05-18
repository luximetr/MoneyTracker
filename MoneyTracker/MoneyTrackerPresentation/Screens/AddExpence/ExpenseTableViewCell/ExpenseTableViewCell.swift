//
//  ExpenseTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class ExpenseTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let accountLabel = UILabel()
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let commentLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(accountLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupAccountLabel(appearance: Appearance) {
        accountLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        accountLabel.textColor = appearance.colors.secondaryText
    }
    
    private func setupCategoryLabel(appearance: Appearance) {
        categoryLabel.font = appearance.fonts.primary(size: 16, weight: .regular)
        categoryLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupAmountLabel(appearance: Appearance) {
        amountLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        amountLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupCommentLabel(appearance: Appearance) {
        commentLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        commentLabel.textColor = appearance.colors.secondaryText
    }
    
    private func setupSeparatorView(appearance: Appearance) {
        separatorView.backgroundColor = appearance.colors.secondaryBackground
    }
    
    // MARK: - Layout
    
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        setupAccountLabel(appearance: appearance)
        setupCategoryLabel(appearance: appearance)
        setupAmountLabel(appearance: appearance)
        setupCommentLabel(appearance: appearance)
        setupSeparatorView(appearance: appearance)
        setIsSelected(_isSelected, animated: false)
    }
    
    // MARK: - Selection
    
    private var _isSelected: Bool = false
    func setIsSelected(_ isSelected: Bool, animated: Bool) {
        self._isSelected = isSelected
        if isSelected {
            backgroundColor = appearance?.colors.selectedBackground
        } else {
            backgroundColor = .clear
        }
    }
    
}
}
