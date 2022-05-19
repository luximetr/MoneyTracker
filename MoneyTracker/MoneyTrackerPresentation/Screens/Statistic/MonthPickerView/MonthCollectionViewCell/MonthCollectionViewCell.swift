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
    
    // MARK: - State
    
    private var _isSelected = false
    func setSelected(_ isSelected: Bool) {
        self._isSelected = isSelected
        if isSelected {
            contentView.backgroundColor = appearance?.colors.primaryActionBackground ?? .clear
            monthLabel.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            monthLabel.textColor = appearance?.colors.secondaryText
        }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        setSelected(_isSelected)
        monthLabel.font = appearance.fonts.primary(size: 12, weight: .medium)
    }
    
}
}
