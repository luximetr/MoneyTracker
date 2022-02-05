//
//  CategoriesScreenCategoryTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenCategoryTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: Data
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init()
    }

}

final class CategoriesScreenCategoryTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let nameLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
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
        layoutSeparatorView()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - 2 * x
        let height = bounds.height - 2 * y - 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
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
