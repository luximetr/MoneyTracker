//
//  SettingsScreenTitleValueTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit

extension SettingsScreenViewController {
final class TitleValueTableViewCell: AUITableViewCell {
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let forwardImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        setupTitleLabel()
        contentView.addSubview(valueLabel)
        setupValueLabel()
        contentView.addSubview(forwardImageView)
        setupForwardImageView()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = Colors.black
    }
    
    private func setupValueLabel() {
        valueLabel.font = Fonts.default(size: 13)
        valueLabel.textColor = Colors.secondaryText
    }
    
    private func setupForwardImageView() {
        forwardImageView.contentMode = .scaleAspectFit
        forwardImageView.image = Images.forwardArrow
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.gray
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutValueLabel()
        layoutForwardImageView()
        layoutSeparatorView()
    }
    
    private func layoutTitleLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height: CGFloat = 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
    }
    
    private func layoutValueLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 37
        let width = bounds.width - x - 40
        let height: CGFloat = 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        valueLabel.frame = frame
    }
    
    private func layoutForwardImageView() {
        let width: CGFloat = 8
        let height: CGFloat = 12
        let x: CGFloat = bounds.width - 32
        let y: CGFloat = 24
        let frame = CGRect(x: x, y: y, width: width, height: height)
        forwardImageView.frame = frame
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 28
        let width = bounds.width - x
        let height: CGFloat = 1
        let y = bounds.height - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            titleLabel.alpha = 0.6
            forwardImageView.alpha = 0.6
        } else {
            titleLabel.alpha = 1
            forwardImageView.alpha = 1
        }
    }
    
}
}
