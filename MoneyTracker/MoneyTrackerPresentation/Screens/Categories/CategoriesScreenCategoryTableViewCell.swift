//
//  CategoriesScreenCategoryTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenCategoryTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let nameLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        setupNameLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.black
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameLabel()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - 2 * x
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
    
    
}
