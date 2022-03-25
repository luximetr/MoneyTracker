//
//  MonthCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
class MonthCollectionViewCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    let monthLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.clipsToBounds = true
        contentView.addSubview(monthLabel)
        setupMonthLabel()
    }
    
    private func setupMonthLabel() {
        monthLabel.font = Fonts.default(size: 12, weight: .medium)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = bounds.height / 2
        layoutMonthLabel()
    }
    
    private func layoutMonthLabel() {
        monthLabel.frame = contentView.frame
        monthLabel.textAlignment = .center
    }
    
    // MARK: State
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = Colors.accent
            monthLabel.textColor = Colors.white
        } else {
            contentView.backgroundColor = .clear
            monthLabel.textColor = Colors.secondaryText
        }
    }
    
    // MARK: - Size
    
    private static let monthCollectionViewCell = MonthCollectionViewCell(frame: .zero)
    static func sizeThatFits(_ size: CGSize, month: String) -> CGSize {
        monthCollectionViewCell.monthLabel.text = month
        let sizeThatFits = monthCollectionViewCell.sizeThatFits(size)
        return sizeThatFits
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = monthLabel.sizeThatFits(size)
        sizeThatFits.width += 10 * 2
        sizeThatFits.height = size.height
        return sizeThatFits
    }
}
}
