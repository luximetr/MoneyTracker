//
//  TemplatesScreenTemplateTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit
import PinLayout

extension TemplatesScreenView {
    
    final class TemplateTableViewCell: AppearanceTableViewCell {
        
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
            contentView.addSubview(amountLabel)
            contentView.addSubview(balanceAccountPrefixLabel)
            contentView.addSubview(balanceAccountLabel)
            contentView.addSubview(categoryPrefixLabel)
            contentView.addSubview(categoryLabel)
            contentView.addSubview(commentLabel)
            contentView.addSubview(separatorView)
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
        
        // MARK: - Appearance
        
        override func setAppearance(_ appearance: Appearance) {
            super.setAppearance(appearance)
            backgroundColor = appearance.colors.primaryBackground
            nameLabel.textColor = appearance.colors.primaryText
            nameLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
            amountLabel.textColor = appearance.colors.primaryText
            amountLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
            balanceAccountPrefixLabel.textColor = appearance.colors.secondaryText
            balanceAccountPrefixLabel.font = appearance.fonts.primary(size: 11, weight: .regular)
            balanceAccountLabel.textColor = appearance.colors.primaryText
            balanceAccountLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
            categoryPrefixLabel.textColor = appearance.colors.secondaryText
            categoryPrefixLabel.font = appearance.fonts.primary(size: 11, weight: .regular)
            categoryLabel.textColor = appearance.colors.primaryText
            categoryLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
            commentLabel.textColor = appearance.colors.secondaryText
            commentLabel.font = appearance.fonts.primary(size: 13, weight: .regular)
            separatorView.backgroundColor = appearance.colors.secondaryBackground
        }
    }
}
