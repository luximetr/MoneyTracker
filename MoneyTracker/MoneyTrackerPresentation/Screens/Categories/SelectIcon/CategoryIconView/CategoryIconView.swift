//
//  CategoryIconView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.04.2022.
//

import AUIKit
import PinLayout

final class CategoryIconView: AUIView {
    
    // MARK: - Subviews
    
    let iconImageView = UIImageView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(iconImageView)
        setupIconImageView()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIconImageView()
    }
    
    // MARK: - IconImageView
    
    func setIcon(named iconName: String) {
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = Colors.darkCardPrimaryText
    }
    
    private func layoutIconImageView() {
        iconImageView.pin
            .height(20)
            .width(20)
            .vCenter()
            .hCenter()
    }
}
