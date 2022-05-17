//
//  DashboardTemplateCollectionCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit
import PinLayout

extension DashboardScreenViewController {
final class TemplateCollectionViewCell: AppearanceCollectionViewCell {
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
        
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    override func layoutContentView() {
        super.layoutContentView()
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .left(5)
            .right(5)
            .vCenter()
            .sizeToFit(.width)
    }
    
    // MARK: - States
    
    override var isHighlighted: Bool {
        willSet {
            willSetIsHighlighted(newValue)
        }
    }
    func willSetIsHighlighted(_ newValue: Bool) {
        if newValue {
            titleLabel.alpha = 0.6
        } else {
            titleLabel.alpha = 1
        }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        contentView.backgroundColor = appearance.primaryBackground
        contentView.layer.borderColor = appearance.tertiaryBackground.cgColor
        titleLabel.textColor = appearance.primaryText
        titleLabel.font = appearance.fonts.primary(size: 18, weight: .regular)
    }
    
}
}
