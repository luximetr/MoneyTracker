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
class CategoryCell: AppearanceTableViewCell {
    
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
            .height(14)
            .width(14)
            .vCenter()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .right(15)
            .left(to: iconView.edge.right).marginLeft(10)
            .vCenter()
            .sizeToFit(.width)
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        titleLabel.font = appearance.fonts.primary(size: 16, weight: .regular)
    }
}
}
