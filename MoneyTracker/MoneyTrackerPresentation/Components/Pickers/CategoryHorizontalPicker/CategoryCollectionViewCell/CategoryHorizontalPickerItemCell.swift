//
//  CategoryHorizontalPickerItemCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class CategoryHorizontalPickerItemCell: AUICollectionViewCell {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(coloredView)
        addSubview(titleLabel)
        setupColoredView()
        setupTitleLabel()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColoredView()
        layoutTitleLabel()
    }
    
    // MARK: - ColoredView
    
    private let coloredView = UIView()
    
    private func setupColoredView() {
        coloredView.backgroundColor = Colors.secondaryBackground
        coloredView.layer.cornerRadius = 12
        coloredView.layer.borderColor = Colors.secondaryBackground.cgColor
        coloredView.layer.borderWidth = 1
    }
    
    private func layoutColoredView() {
        coloredView.pin.all()
    }
    
    private func getColoredViewBackgroundColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return Colors.secondaryBackground
        } else {
            return Colors.white
        }
    }
    
    // MARK: - TitleLabel
    
    let titleLabel = UILabel()
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 11, weight: .regular)
        titleLabel.textAlignment = .center
    }
    
    private func getTitleLabelTextColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return Colors.primaryText
        } else {
            return Colors.secondaryText
        }
    }
    
    private let titleLabelHorizontalOffset: CGFloat = 6
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .vertically(1)
            .horizontally(titleLabelHorizontalOffset)
    }
    
    func update(isSelected: Bool) {
        titleLabel.textColor = getTitleLabelTextColor(isSelected: isSelected)
        coloredView.backgroundColor = getColoredViewBackgroundColor(isSelected: isSelected)
    }
    
    // MARK: - Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let availableSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: size.height)
        let labelWidth = titleLabel.sizeThatFits(availableSize).width
        let takenWidth = titleLabelHorizontalOffset * 2 + labelWidth
        let takenSize = CGSize(width: takenWidth, height: size.height)
        return takenSize
    }
}
