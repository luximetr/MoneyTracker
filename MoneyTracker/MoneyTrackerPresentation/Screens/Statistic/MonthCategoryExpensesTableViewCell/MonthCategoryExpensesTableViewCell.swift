//
//  MonthCategoryExpensesTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthCategoryExpensesTableViewCell: AppearanceTableViewCell {
    
    // MARK: Subviews
    
    let categoryIconView = CategoryIconView()
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(categoryIconView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupCategoryLabel(appearance: Appearance) {
        categoryLabel.font = Fonts.default(size: 17, weight: .regular)
        categoryLabel.textColor = appearance.primaryText
    }
    
    private func setupAmountLabel(appearance: Appearance) {
        amountLabel.font = Fonts.default(size: 17, weight: .regular)
        amountLabel.textColor = appearance.primaryText
        amountLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupSeparatorView(appearance: Appearance) {
        separatorView.backgroundColor = appearance.secondaryBackground
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCategoryIconView()
        layoutCategoryLabel()
        layoutAmountLabel()
        layoutSeparatorView()
    }
    
    private let categoryIconViewLeft: CGFloat = 24
    private let categoryIconViewSide: CGFloat = 40
    
    private func layoutCategoryIconView() {
        let x = categoryIconViewLeft
        let y: CGFloat = frame.height / 2 - categoryIconViewSide / 2
        let height = categoryIconViewSide
        let width = categoryIconViewSide
        let frame = CGRect(x: x, y: y, width: width, height: height)
        categoryIconView.frame = frame
        categoryIconView.layer.cornerRadius = height / 2
    }
    
    private func layoutCategoryLabel() {
        let x: CGFloat = categoryIconViewLeft + categoryIconViewSide + 16
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        categoryIconView.iconImageView.tintColor = appearance.categoryPrimaryText
        setupCategoryLabel(appearance: appearance)
        setupAmountLabel(appearance: appearance)
        setupSeparatorView(appearance: appearance)
    }
    
}
}
