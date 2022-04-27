//
//  CategoryVerticalPickerCategoryCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension CategoryVerticalPickerView {
class CategoryCell: AUITableViewCell {
    
    // MARK: - Subviews
    
    let iconView = UIImageView()
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(iconView)
        setupIconView()
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 14, weight: .regular)
        titleLabel.numberOfLines = 1
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIconView()
        layoutTitleLabel()
    }
    
    private func layoutIconView() {
        iconView.pin
            .left(15)
            .height(12)
            .width(12)
            .vCenter()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .right(15)
            .left(to: iconView.edge.right).marginLeft(10)
            .vCenter()
            .sizeToFit(.width)
    }
}
}
