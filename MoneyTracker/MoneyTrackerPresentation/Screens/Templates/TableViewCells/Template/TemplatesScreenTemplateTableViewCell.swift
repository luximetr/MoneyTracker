//
//  TemplatesScreenTemplateTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit
import PinLayout

final class TemplatesScreenTemplateTableViewCell: AUITableViewCell {
    
    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let amountLabel = UILabel()
    let balanceAccountPrefixLabel = UILabel()
    let balanceAccountLabel = UILabel()
    let categoryPrefixLabel = UILabel()
    let categoryLabel = UILabel()
    let commentLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(amountLabel)
        setupAmountLabel()
        contentView.addSubview(balanceAccountPrefixLabel)
        setupBalanceAccountPrefixLabel()
        contentView.addSubview(balanceAccountLabel)
        setupBalanceAccountLabel()
        contentView.addSubview(categoryPrefixLabel)
        setupCategoryPrefixLabel()
        contentView.addSubview(categoryLabel)
        setupCategoryLabel()
        contentView.addSubview(commentLabel)
        setupCommentLabel()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupNameLabel() {
        nameLabel.font = Fonts.default(size: 17)
        nameLabel.textColor = Colors.primaryText
    }
    
    private func setupAmountLabel() {
        amountLabel.font = Fonts.default(size: 17)
        amountLabel.textColor = Colors.primaryText
    }
    
    private func setupBalanceAccountPrefixLabel() {
        balanceAccountPrefixLabel.font = Fonts.default(size: 11)
        balanceAccountPrefixLabel.textColor = Colors.secondaryText
    }
    
    private func setupBalanceAccountLabel() {
        balanceAccountLabel.font = Fonts.default(size: 14)
        balanceAccountLabel.textColor = Colors.primaryText
    }
    
    private func setupCategoryPrefixLabel() {
        categoryPrefixLabel.font = Fonts.default(size: 11)
        categoryPrefixLabel.textColor = Colors.secondaryText
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Fonts.default(size: 14)
        categoryLabel.textColor = Colors.primaryText
    }
    
    private func setupCommentLabel() {
        commentLabel.font = Fonts.default(size: 13)
        commentLabel.textColor = Colors.secondaryText
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.secondaryBackground
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAmountLabel()
        layoutCommentLabel()
        layoutNameLabel()
        layoutBalanceAccountPrefixLabel()
        layoutBalanceAccountLabel()
        layoutCategoryPrefixLabel()
        layoutCategoryLabel()
    }
    
    private func layoutNameLabel() {
        nameLabel.pin
            .left(20)
            .right(to: amountLabel.edge.left).marginRight(10)
            .bottom(to: amountLabel.edge.bottom)
            .sizeToFit(.width)
    }
    
    private func layoutAmountLabel() {
        amountLabel.pin
            .right(20)
            .top(10)
            .sizeToFit()
    }
    
    private func layoutBalanceAccountPrefixLabel() {
        balanceAccountPrefixLabel.pin
            .left(to: nameLabel.edge.left)
            .right(to: nameLabel.edge.right)
            .below(of: nameLabel).marginTop(4)
            .sizeToFit()
    }
    
    private func layoutBalanceAccountLabel() {
        balanceAccountLabel.pin
            .after(of: balanceAccountPrefixLabel).marginLeft(4)
            .right(to: nameLabel.edge.right)
            .bottom(to: balanceAccountPrefixLabel.edge.bottom)
            .sizeToFit(.width)
    }
    
    private func layoutCategoryPrefixLabel() {
        categoryPrefixLabel.pin
            .left(to: balanceAccountPrefixLabel.edge.left)
            .below(of: balanceAccountPrefixLabel).marginTop(4)
            .sizeToFit()
    }
    
    private func layoutCategoryLabel() {
        categoryLabel.pin
            .after(of: categoryPrefixLabel).marginLeft(4)
            .bottom(to: categoryPrefixLabel.edge.bottom)
            .right(to: commentLabel.edge.left).marginRight(10)
            .sizeToFit(.width)
    }
    
    private func layoutCommentLabel() {
        commentLabel.pin
            .right(to: amountLabel.edge.right)
            .bottom(10)
            .maxWidth(50%)
            .sizeToFit()
    }
    
}
