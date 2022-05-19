//
//  SelectIconScreenCollectionCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import AUIKit
import PinLayout

extension SelectIconScreenViewController.ScreenView {
final class IconCell: AppearanceCollectionViewCell {
    
    // MARK: - Subviews
    
    let iconView = CategoryIconView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(iconView)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIconView()
    }
    
    private func layoutIconView() {
        iconView.pin.all()
        iconView.layer.cornerRadius = iconView.frame.height / 2
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        iconView.iconImageView.tintColor = appearance.colors.categoryPrimaryText
    }
}
}
