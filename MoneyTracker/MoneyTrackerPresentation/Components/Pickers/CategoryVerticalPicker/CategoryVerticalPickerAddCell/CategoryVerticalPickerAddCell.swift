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
    
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.font = Fonts.default(size: 14, weight: .regular)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .left(14)
            .right(14)
            .vCenter()
            .sizeToFit(.width)
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
    }
}
}
