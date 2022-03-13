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
    private let selectedMarkView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(coloredView)
        addSubview(selectedMarkView)
        addSubview(titleLabel)
        setupColoredView()
        setupTitleLabel()
        setupSelectedMarkView()
        update(isSelected: false)
    }
    
    // MARK: - ColoredView
    
    private func setupColoredView() {
        coloredView.layer.cornerRadius = 5
    }
    
    private func layoutColoredView() {
        coloredView.pin.all()
    }
    
    // MARK: - TitleLabel
    
    private func setupTitleLabel() {
        titleLabel.textColor = Colors.darkCardPrimaryText
        titleLabel.font = Fonts.default(size: 12, weight: .regular)
        titleLabel.textAlignment = .center
    }
    
    private let titleLabelHorizontalOffset: CGFloat = 11
    
    private func layoutTitleLabel() {
        titleLabel.pin
            .vertically(2)
            .horizontally(titleLabelHorizontalOffset)
    }
    
    // MARK: - SelectedMarkView
    
    private func setupSelectedMarkView() {
        selectedMarkView.backgroundColor = .clear
        selectedMarkView.layer.cornerRadius = 4
        selectedMarkView.layer.borderColor = Colors.primaryBackground.cgColor
        selectedMarkView.layer.borderWidth = 1
    }
    
    private func layoutSelectedMarkView() {
        selectedMarkView.pin
            .left(to: coloredView.edge.left).marginLeft(1)
            .right(to: coloredView.edge.right).marginRight(1)
            .top(to: coloredView.edge.top).marginTop(1)
            .bottom(to: coloredView.edge.bottom).marginBottom(1)
    }
    
    func update(isSelected: Bool) {
        selectedMarkView.isHidden = !isSelected
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColoredView()
        layoutTitleLabel()
        layoutSelectedMarkView()
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
