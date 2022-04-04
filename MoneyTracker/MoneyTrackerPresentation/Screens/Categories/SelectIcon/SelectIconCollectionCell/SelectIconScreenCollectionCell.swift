//
//  SelectIconScreenCollectionCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import AUIKit
import PinLayout

extension SelectIconScreenViewController.ScreenView {
final class IconCell: AUICollectionViewCell {
    
    // MARK: - Subviews
    
    let iconView = CategoryIconView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(iconView)
        setupIconView()
    }
    
    private func setupIconView() {
        iconView.iconImageView.tintColor = Colors.darkCardPrimaryText
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
}
}
