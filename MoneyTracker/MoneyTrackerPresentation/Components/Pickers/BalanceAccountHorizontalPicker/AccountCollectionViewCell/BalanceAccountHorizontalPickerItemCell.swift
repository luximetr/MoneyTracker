//
//  BalanceAccountHorizontalPickerItemCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class BalanceAccountHorizontalPickerItemCell: AppearanceCollectionViewCell {
    
    // MARK: - UI elements
    
    let coloredView = UIView()
    let titleLabel = UILabel()
    private(set) var color: UIColor = .clear
    
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
    }
    
    private func layoutColoredView() {
        coloredView.pin.all()
    }
    
    // MARK: - TitleLabel
    
    private func setupTitleLabel() {
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
        if isSelected {
            titleLabel.textColor = appearance?.balanceAccountPrimaryText
            coloredView.backgroundColor = color
        } else {
            titleLabel.textColor = color
            coloredView.backgroundColor = .clear
        }
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
        coloredView.layer.borderColor = color.cgColor
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
        let takenSize = CGSize(width: takenWidth, height: titleLabel.sizeThatFits(availableSize).height + 8)
        return takenSize
    }
    
    private static let balanceAccountHorizontalPickerItemCell = BalanceAccountHorizontalPickerItemCell()
    static func sizeThatFits(_ size: CGSize, name: String) -> CGSize {
        balanceAccountHorizontalPickerItemCell.titleLabel.text = name
        let sizeThatFits = balanceAccountHorizontalPickerItemCell.sizeThatFits(size)
        return sizeThatFits
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        titleLabel.textColor = appearance.balanceAccountPrimaryText
    }
    
}
