//
//  DashboardCategoryPickerCategoryCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 21.04.2022.
//

import UIKit

extension DashboardScreenViewController.CategoryPickerView {
final class CategoryCell: AppearanceCollectionViewCell {
    
    // MARK: - Subviews
    
    private let coloredView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(coloredView)
        addSubview(iconView)
        addSubview(titleLabel)
        setupColoredView()
        setupIconView()
        setupTitleLabel()
    }
    
    private func setupColoredView() {
        coloredView.layer.borderWidth = 1
    }
    
    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColoredView()
        layoutIconView()
        layoutTitleLabel()
    }
    
    private func layoutColoredView() {
        coloredView.pin
            .left()
            .top()
            .right()
            .bottom()
        coloredView.layer.cornerRadius = coloredView.frame.height / 2
    }
    
    private let iconViewLeft: CGFloat = 8
    private let iconViewSide: CGFloat = 12
    
    private func layoutIconView() {
        iconView.pin
            .height(iconViewSide)
            .width(iconViewSide)
            .left(iconViewLeft)
            .vCenter(to: coloredView.edge.vCenter)
    }
    
    private let titleLabelLeft: CGFloat = 5
    private let titleLabelRight: CGFloat = 6
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .top(to: coloredView.edge.top).marginTop(1)
            .bottom(to: coloredView.edge.bottom).marginBottom(1)
            .left(to: iconView.edge.right).marginLeft(titleLabelLeft)
            .right(titleLabelRight)
    }
    
    // MARK: - Size
    
    private static let categoryHorizontalPickerItemCell = CategoryHorizontalPickerItemCell()
    static func sizeThatFits(_ size: CGSize, name: String) -> CGSize {
        categoryHorizontalPickerItemCell.titleLabel.text = name
        let sizeThatFits = categoryHorizontalPickerItemCell.sizeThatFits(size)
        return sizeThatFits
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let availableSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: size.height)
        let labelWidth = titleLabel.sizeThatFits(availableSize).width
        let takenWidth = iconViewLeft + iconViewSide + titleLabelLeft + labelWidth + titleLabelRight
        let takenHeight = titleLabel.sizeThatFits(availableSize).height + 10
        let takenSize = CGSize(width: takenWidth, height: takenHeight)
        return takenSize
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        iconView.tintColor = appearance.secondaryText
        titleLabel.textColor = appearance.secondaryText
        titleLabel.font = appearance.fonts.primary(size: 11, weight: .regular)
        coloredView.backgroundColor = appearance.transparent
        coloredView.layer.borderColor = appearance.colors.secondaryBackground.cgColor
    }
}
}
