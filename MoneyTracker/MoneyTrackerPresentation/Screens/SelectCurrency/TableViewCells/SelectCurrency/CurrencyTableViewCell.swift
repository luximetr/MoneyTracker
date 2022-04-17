//
//  SelectCurrencyTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import UIKit
import AUIKit
import PinLayout

extension SelectCurrencyScreenViewController {
class CurrencyTableViewCell: AppearanceTableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let codeLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(codeLabel)
    }
    
    private func setupNameLabel(appearance: Appearance) {
        nameLabel.textColor = appearance.primaryText
    }
    
    private func setupCodeLabel(appearance: Appearance) {
        codeLabel.textColor = appearance.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCodeLabel()
        layoutNameLabel()
    }
    
    private func layoutNameLabel() {
        nameLabel.pin
            .vCenter()
            .left()
            .right(to: codeLabel.edge.left)
            .sizeToFit(.width)
            .marginLeft(28)
    }
    
    private func layoutCodeLabel() {
        codeLabel.pin
            .vCenter()
            .right(pin.safeArea)
            .sizeToFit()
            .marginRight(28)
    }
    
    // MARK: - Update
    
    override var isSelected: Bool {
        get { return super.isSelected }
        set {
            codeLabel.textColor = getCodeLabelColor(isSelected: isSelected)
            super.isSelected = newValue
        }
    }
    
    private func getCodeLabelColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return appearance?.accent ?? .clear
        } else {
            return appearance?.primaryText ?? .clear
        }
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        setupNameLabel(appearance: appearance)
        setupCodeLabel(appearance: appearance)
    }
}
}
