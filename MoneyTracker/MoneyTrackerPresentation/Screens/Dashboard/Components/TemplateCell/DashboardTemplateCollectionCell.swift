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
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = Colors.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
    }
    
    private func layoutTitleLabel() {
        
    }
}
