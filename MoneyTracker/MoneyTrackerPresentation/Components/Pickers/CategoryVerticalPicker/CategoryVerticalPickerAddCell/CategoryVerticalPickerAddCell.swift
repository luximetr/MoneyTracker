//
//  CategoryVerticalPickerAddCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import Foundation
import UIKit
import PinLayout

extension CategoryVerticalPickerView {
class AddCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let prefixLabel = UILabel()
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(prefixLabel)
        setupPrefixLabel()
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    private func setupPrefixLabel() {
        prefixLabel.numberOfLines = 1
        prefixLabel.text = "+"
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPrefixLabel()
        layoutTitleLabel()
    }
    
    private func layoutPrefixLabel() {
        prefixLabel.pin
            .left(17)
            .vCenter()
            .sizeToFit()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .left(to: prefixLabel.edge.right).marginLeft(12)
            .right(14)
            .vCenter()
            .sizeToFit(.width)
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        prefixLabel.textColor = appearance.colors.primaryText
        prefixLabel.font = appearance.fonts.primary(size: 16, weight: .regular)
        titleLabel.textColor = appearance.colors.primaryText
        titleLabel.font = appearance.fonts.primary(size: 16, weight: .regular)
    }
}
}
