//
//  SelectCurrencyTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyTableViewCell: AUITableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let codeLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = .green
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
        layoutNameLabel()
        layoutCodeLabel()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
    private func layoutCodeLabel() {
        
    }
}
