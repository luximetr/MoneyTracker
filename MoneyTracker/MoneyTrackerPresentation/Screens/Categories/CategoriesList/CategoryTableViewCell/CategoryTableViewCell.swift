//
//  CategoriesScreenCategoryTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

extension CategoriesScreenViewController {
final class CategoryTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let iconView = CategoryIconView()
    let nameLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(separatorView)
        setupSeparatorView()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.black
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.gray
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameLabel()
        layoutIconView()
        layoutSeparatorView()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = iconViewLeading + iconViewSide + 16
        let y: CGFloat = 12
        let width = bounds.width - 2 * x
        let height = bounds.height - 2 * y - 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
    private let iconViewLeading: CGFloat = 24
    private let iconViewSide: CGFloat = 40
    
    private func layoutIconView() {
        let x: CGFloat = iconViewLeading
        let y: CGFloat = nameLabel.frame.midY - iconViewSide / 2
        let width: CGFloat = iconViewSide
        let height: CGFloat = iconViewSide
        let frame = CGRect(x: x, y: y, width: width, height: height)
        iconView.frame = frame
        iconView.layer.cornerRadius = height / 2
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
        } else {
            nameLabel.alpha = 1
        }
    }
    
}
}
