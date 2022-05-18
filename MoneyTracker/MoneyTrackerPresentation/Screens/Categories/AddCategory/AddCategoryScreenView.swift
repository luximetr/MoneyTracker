//
//  AddCategoryScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import UIKit
import AUIKit

extension AddCategoryScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let iconView = CategoryIconView()
    let selectIconButton = UIButton()
    let scrollView = UIScrollView()
    let nameTextField: PlainTextField
    let colorPickerTitleLabel = UILabel()
    let colorPickerView: ColorHorizontalPickerView
    let addButton: TextFilledButton
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        self.nameTextField = PlainTextField(appearance: appearance)
        self.colorPickerView = ColorHorizontalPickerView(appearance: appearance)
        self.addButton = TextFilledButton(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(scrollView)
        iconView.backgroundColor = appearance.colors.secondaryBackground
        scrollView.addSubview(iconView)
        scrollView.addSubview(selectIconButton)
        scrollView.addSubview(nameTextField)
        setupNameTextField()
        scrollView.addSubview(colorPickerTitleLabel)
        setupColorPickerTitleLabel()
        scrollView.addSubview(colorPickerView)
        setupColorPickerView()
        addSubview(addButton)
        setupAddButton()
        changeAppearance(appearance)
        addSubview(errorSnackbarView)
    }
    
    private func setupNameTextField() {
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .none
    }
    
    private func setupColorPickerTitleLabel() {
        colorPickerTitleLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
    }
    
    private func setupColorPickerView() {
        colorPickerView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func setupAddButton() {
        addButton.titleLabel?.font = appearance.fonts.primary(size: 17, weight: .semibold)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutNameTextField()
        layoutIconView()
        layoutSelectIconButton()
        layoutColorPickerTitleLabel()
        layoutColorPickerView()
        layoutAddButton()
        setScrollViewContentSize()
        layoutErrorSnackbarView()
    }
    
    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        scrollView.frame = frame
    }
    
    private func layoutNameTextField() {
        let x: CGFloat = iconViewLeading + iconViewSide + 16
        let y: CGFloat = 32
        let width = bounds.width - x - iconViewLeading
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameTextField.frame = frame
    }
    
    private let iconViewLeading: CGFloat = 16
    private let iconViewSide: CGFloat = 40
    
    private func layoutIconView() {
        let x: CGFloat = iconViewLeading
        let heightDifference = nameTextField.frame.height - iconViewSide
        let y: CGFloat = nameTextField.frame.origin.y + heightDifference / 2
        let size = CGSize(width: iconViewSide, height: iconViewSide)
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
        iconView.frame = frame
        iconView.layer.cornerRadius = iconViewSide / 2
    }
    
    private func layoutSelectIconButton() {
        let frame = iconView.frame
        selectIconButton.frame = frame
    }
    
    private func layoutColorPickerTitleLabel() {
        let x: CGFloat = iconViewLeading
        let y: CGFloat = nameTextField.frame.maxY + 24
        let width: CGFloat = bounds.width - 2 * x
        let availableSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = colorPickerTitleLabel.sizeThatFits(availableSize)
        colorPickerTitleLabel.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    private func layoutColorPickerView() {
        let x: CGFloat = 0
        let y: CGFloat = colorPickerTitleLabel.frame.maxY + 8
        let width: CGFloat = bounds.width
        let height: CGFloat = 36
        let frame = CGRect(x: x, y: y, width: width, height: height)
        colorPickerView.frame = frame
    }
    
    private func setScrollViewContentSize() {
        let width = scrollView.bounds.width
        let height = colorPickerView.frame.maxY + 16.0 + safeAreaInsets.bottom
        let contentSize = CGSize(width: width, height: height)
        scrollView.contentSize = contentSize
    }
    
    private func layoutAddButton() {
        let x: CGFloat = 44
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let y = bounds.height - 16 - height - safeAreaInsets.bottom
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
    }
    
    private func layoutErrorSnackbarView() {
        let x: CGFloat = 10
        let width = bounds.width - x * 2
        let availableSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height: CGFloat = errorSnackbarView.sizeThatFits(availableSize).height
        let y = navigationBarView.frame.minY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        errorSnackbarView.frame = frame
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        scrollView.backgroundColor = appearance.colors.primaryBackground
        iconView.iconImageView.tintColor = appearance.categoryPrimaryText
        colorPickerTitleLabel.textColor = appearance.colors.primaryText
        nameTextField.changeAppearance(appearance)
        addButton.setTitleColor(appearance.colors.primaryActionText, for: .normal)
        addButton.backgroundColor = appearance.colors.primaryActionBackground
        errorSnackbarView.changeAppearance(appearance)
    }
    
}
}
