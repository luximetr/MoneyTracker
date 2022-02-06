//
//  SettingsScreenTitleItemTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.02.2022.
//

import UIKit
import AUIKit

extension SettingsScreenView {
final class TitleItemTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let nameLabel = UILabel()
    let forwardImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(forwardImageView)
        setupForwardImageView()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.black
    }
    
    private func setupForwardImageView() {
        forwardImageView.contentMode = .scaleAspectFit
        forwardImageView.image = Images.forwardArrow
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.gray
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameLabel()
        layoutForwardImageView()
        layoutSeparatorView()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height = bounds.height - 2 * y - 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
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
            nameLabel.alpha = 0.6
            forwardImageView.alpha = 0.6
        } else {
            nameLabel.alpha = 1
            forwardImageView.alpha = 1
        }
    }
    
}
}
