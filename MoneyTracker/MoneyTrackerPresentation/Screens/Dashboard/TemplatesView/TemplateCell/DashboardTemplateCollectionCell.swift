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
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.masksToBounds = false
        contentView.backgroundColor = appearance?.primaryBackground
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
        
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.default(size: 18, weight: .regular)
        titleLabel.textColor = appearance?.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layoutTitleLabel()
    }
    
    override func layoutContentView() {
        super.layoutContentView()
        contentView.layer.cornerRadius = 10
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
            layer.shadowOpacity = 0.4
            contentView.alpha = 0.6
        } else {
            layer.shadowOpacity = 1
            contentView.alpha = 1
        }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        contentView.backgroundColor = appearance.primaryBackground
        titleLabel.textColor = appearance.primaryText
    }
    
}
}
