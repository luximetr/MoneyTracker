//
//  DateHorizontalPickerDateCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.05.2022.
//

import UIKit
import PinLayout

extension DateHorizontalPickerView {
class DateCell: AppearanceCollectionViewCell {
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 14, weight: .regular)
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .top()
            .bottom()
            .left()
            .right()
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        titleLabel.textColor = appearance.primaryText
    }
}
}
