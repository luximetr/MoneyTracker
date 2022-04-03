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
    
    func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func layoutIconImageView() {
        iconImageView.pin
            .height(20)
            .width(20)
            .vCenter()
            .hCenter()
    }
}
