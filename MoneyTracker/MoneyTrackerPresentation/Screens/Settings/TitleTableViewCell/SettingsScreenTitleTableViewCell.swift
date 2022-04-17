//
//  SettingsScreenTitleItemTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

extension SettingsScreenViewController {
final class TitleTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        setupTitleLabel(appearance: appearance)
        setupForwardImageView(appearance: appearance)
        setupSeparatorView(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    let forwardImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(forwardImageView)
        contentView.addSubview(separatorView)
    }
    
    private func setupTitleLabel(appearance: Appearance) {
        titleLabel.textColor = appearance.primaryText
    }
    
    private func setupForwardImageView(appearance: Appearance) {
        forwardImageView.contentMode = .scaleAspectFit
        forwardImageView.image = Images.forwardArrow.withRenderingMode(.alwaysTemplate)
        forwardImageView.tintColor = appearance.primaryText
    }
    
    private func setupSeparatorView(appearance: Appearance) {
        separatorView.backgroundColor = appearance.secondaryBackground
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutForwardImageView()
        layoutSeparatorView()
    }
    
    private func layoutTitleLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
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
    
    // MARK: - Highlighted
    
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
