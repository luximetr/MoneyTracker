//
//  MonthCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
class MonthCollectionViewCell: AppearanceCollectionViewCell {
    
    // MARK: - Subviews
    
    let monthLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(monthLabel)
        setupMonthLabel()
    }
    
    private func setupMonthLabel() {
        monthLabel.font = Fonts.default(size: 12, weight: .medium)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMonthLabel()
    }
    
    override func layoutContentView() {
        super.layoutContentView()
        contentView.layer.cornerRadius = bounds.height / 2
    }
    
    private func layoutMonthLabel() {
        monthLabel.frame = contentView.frame
        monthLabel.textAlignment = .center
    }
    
    // MARK: - State
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = appearance?.accent ?? .clear
            monthLabel.textColor = appearance?.primaryText
        } else {
            contentView.backgroundColor = .clear
            monthLabel.textColor = appearance?.secondaryText
        }
    }
    
    // MARK: - Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = monthLabel.sizeThatFits(size)
        sizeThatFits.width += 12 * 2
        sizeThatFits.height = size.height
        return sizeThatFits
    }
    
    private static let monthCollectionViewCell = MonthCollectionViewCell(frame: .zero)
    static func sizeThatFits(_ size: CGSize, month: String) -> CGSize {
        monthCollectionViewCell.monthLabel.text = month
        let sizeThatFits = monthCollectionViewCell.sizeThatFits(size)
        return sizeThatFits
    }
    
}
}
