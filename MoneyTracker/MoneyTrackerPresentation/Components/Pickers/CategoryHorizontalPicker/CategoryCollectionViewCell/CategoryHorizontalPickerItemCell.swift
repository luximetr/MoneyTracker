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
        coloredView.backgroundColor = Colors.secondaryBackground
        coloredView.layer.cornerRadius = 12
    }
    
    private func setupIconView() {
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 11, weight: .regular)
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
//        coloredView.pin.all()
        coloredView.pin
            .left()
            .top(10)
            .right()
            .bottom(10)
    }
    
    private let iconViewLeft: CGFloat = 8
    private let iconViewSide: CGFloat = 12
    
    private func layoutIconView() {
        iconView.pin
            .height(iconViewSide)
            .width(iconViewSide)
            .left(iconViewLeft)
            .vCenter()
    }
    
    private let titleLabelLeft: CGFloat = 5
    private let titleLabelRight: CGFloat = 6
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .vertically(1)
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
        let takenSize = CGSize(width: takenWidth, height: titleLabel.sizeThatFits(availableSize).height + 28)
        return takenSize
    }
    
    // MARK: - IsSelected
    
    func update(isSelected: Bool) {
        if isSelected {
            configureSelected()
        } else {
            configureDeselected()
        }
    }
    
    private func configureSelected() {
        coloredView.backgroundColor = Colors.primaryBackground
        coloredView.layer.shadowOffset = CGSize(width: 0, height: 1)
        coloredView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        coloredView.layer.shadowOpacity = 1
        coloredView.layer.shadowRadius = 2
        coloredView.layer.borderWidth = 0
    }
    
    private func configureDeselected() {
        coloredView.backgroundColor = Colors.transparent
        coloredView.layer.shadowOffset = CGSize(width: 0, height: 0)
        coloredView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        coloredView.layer.shadowOpacity = 0
        coloredView.layer.shadowRadius = 0
        coloredView.layer.borderColor = Colors.secondaryBackground.cgColor
        coloredView.layer.borderWidth = 1
    }
}
