//
//  DashboardTemplateCollectionCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class DashboardTemplateCollectionCell: AUICollectionViewCell {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(coloredView)
        addSubview(titleLabel)
        setupColoredView()
        setupTitleLabel()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColoredView()
        layoutTitleLabel()
    }
    
    // MARK: - ColoredView
    
    private let coloredView = UIView()
    
    private func setupColoredView() {
        coloredView.backgroundColor = Colors.secondaryBackground
        coloredView.layer.cornerRadius = 10
    }
    
    private func layoutColoredView() {
        coloredView.pin.all()
    }
    
    // MARK: - TitleLabel
    
    let titleLabel = UILabel()
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.default(size: 18, weight: .regular)
        titleLabel.textColor = Colors.primaryText
    }
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .left(5)
            .right(5)
            .vCenter()
            .sizeToFit(.width)
    }
}
