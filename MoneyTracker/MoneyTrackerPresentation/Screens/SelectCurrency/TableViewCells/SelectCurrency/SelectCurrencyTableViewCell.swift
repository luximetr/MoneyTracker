//
//  SelectCurrencyTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import UIKit
import AUIKit
import PinLayout

class SelectCurrencyTableViewCell: AUITableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let codeLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(codeLabel)
        setupCodeLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.primaryText
    }
    
    private func setupCodeLabel() {
        codeLabel.textColor = Colors.primaryText
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
            return Colors.accent
        } else {
            return Colors.primaryText
        }
    }
}
