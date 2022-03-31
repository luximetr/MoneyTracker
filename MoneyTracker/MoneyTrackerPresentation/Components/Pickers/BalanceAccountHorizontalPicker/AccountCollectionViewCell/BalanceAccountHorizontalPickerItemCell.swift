//
//  BalanceAccountHorizontalPickerItemCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class BalanceAccountHorizontalPickerItemCell: AUICollectionViewCell {
    
    // MARK: - UI elements
    
    let coloredView = UIView()
    let titleLabel = UILabel()
    var color: UIColor = .clear
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(coloredView)
        addSubview(titleLabel)
        setupColoredView()
        setupTitleLabel()
        update(isSelected: false)
    }
    
    // MARK: - ColoredView
    
    private func setupColoredView() {
        coloredView.layer.cornerRadius = 5
        coloredView.layer.borderWidth = 1
        coloredView.layer.borderColor = color.cgColor
    }
    
    private func layoutColoredView() {
        coloredView.pin.all()
    }
    
    // MARK: - TitleLabel
    
    private func setupTitleLabel() {
        titleLabel.textColor = Colors.darkCardPrimaryText
        titleLabel.font = Fonts.default(size: 12, weight: .semibold)
        titleLabel.textAlignment = .center
    }
    
    private let titleLabelHorizontalOffset: CGFloat = 11
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .vertically(2)
            .horizontally(titleLabelHorizontalOffset)
    }
    
    // MARK: - SelectedMarkView
    
    func update(isSelected: Bool) {
        coloredView.layer.borderColor = color.cgColor
        if isSelected {
            titleLabel.textColor = Colors.white
            coloredView.backgroundColor = color
        } else {
            titleLabel.textColor = color
            coloredView.backgroundColor = .clear
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColoredView()
        layoutTitleLabel()
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
