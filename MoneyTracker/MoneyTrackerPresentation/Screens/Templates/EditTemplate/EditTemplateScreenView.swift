//
//  EditTemplateScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 20.03.2022.
//

import UIKit
import AUIKit
import PinLayout

final class EditTemplateScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let balanceAccountPickerHeaderLabel = UILabel()
    let balanceAccountPickerView: BalanceAccountHorizontalPickerView
    let categoryPickerHeaderLabel = UILabel()
    let categoryPickerView: CategoryHorizontalPickerView
    let nameTextField: PlainTextField
    let amountInputView: SingleLineTextInputView
    let commentTextField: PlainTextField
    let saveButton: TextFilledButton
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        balanceAccountPickerView = BalanceAccountHorizontalPickerView(appearance: appearance)
        categoryPickerView = CategoryHorizontalPickerView(appearance: appearance)
        nameTextField = PlainTextField(appearance: appearance)
        amountInputView = SingleLineTextInputView(appearance: appearance)
        commentTextField = PlainTextField(appearance: appearance)
        self.saveButton = TextFilledButton(appearance: appearance)
        errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(balanceAccountPickerHeaderLabel)
        addSubview(balanceAccountPickerView)
        addSubview(categoryPickerHeaderLabel)
        addSubview(categoryPickerView)
        addSubview(nameTextField)
        addSubview(amountInputView)
        addSubview(commentTextField)
        addSubview(saveButton)
        addSubview(errorSnackbarView)
        setupBalanceAccountPickerHeaderLabel()
        setupCategoryPickerHeaderLabel()
        setAppearance(appearance)
    }
    
    private func setupBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
        balanceAccountPickerHeaderLabel.numberOfLines = 1
    }
    
    private func setupCategoryPickerHeaderLabel() {
        categoryPickerHeaderLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
        categoryPickerHeaderLabel.numberOfLines = 1
    }
    
    // MARK: - Layout
    
    private let marginLeft: CGFloat = 24
    private let marginRight: CGFloat = 24
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameTextField()
        layoutAmountInputView()
        layoutCommentTextField()
        layoutBalanceAccountPickerHeaderLabel()
        layoutBalanceAccountPickerView()
        layoutCategoryPickerHeaderLabel()
        layoutCategoryPickerView()
        layoutSaveButton()
        layoutErrorSnackbarView()
    }
    
    private func layoutBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.pin
            .left(marginLeft)
            .top(to: commentTextField.edge.bottom).marginTop(15)
            .right(marginRight)
            .sizeToFit(.width)
    }
    
    private func layoutBalanceAccountPickerView() {
        balanceAccountPickerView.pin
            .top(to: balanceAccountPickerHeaderLabel.edge.bottom).marginTop(10)
            .left(marginLeft)
            .right(marginRight)
            .height(30)
    }
    
    private func layoutCategoryPickerHeaderLabel() {
        categoryPickerHeaderLabel.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: balanceAccountPickerView.edge.bottom).marginTop(15)
            .sizeToFit(.width)
    }
    
    private func layoutCategoryPickerView() {
        categoryPickerView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: categoryPickerHeaderLabel.edge.bottom).marginTop(10)
            .height(30)
    }
    
    private func layoutNameTextField() {
        nameTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: navigationBarView.edge.bottom).marginTop(24)
            .height(44)
    }
    
    private func layoutAmountInputView() {
        amountInputView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: nameTextField.edge.bottom).marginTop(15)
            .height(44)
    }
    
    private func layoutCommentTextField() {
        commentTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: amountInputView.edge.bottom).marginTop(15)
            .height(44)
    }
    
    private func layoutSaveButton() {
        saveButton.pin
            .hCenter()
            .bottom(pin.safeArea).marginBottom(24)
            .width(150)
            .height(44)
    }
    
    private func layoutErrorSnackbarView() {
        errorSnackbarView.pin
            .left(10)
            .right(10)
            .top(to: navigationBarView.edge.top)
            .sizeToFit(.width)
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        statusBarView.backgroundColor = appearance.colors.primaryBackground
        navigationBarView.backgroundColor = appearance.colors.primaryBackground
        balanceAccountPickerHeaderLabel.textColor = appearance.colors.secondaryText
        balanceAccountPickerView.setAppearance(appearance)
        categoryPickerHeaderLabel.textColor = appearance.colors.secondaryText
        categoryPickerView.setAppearance(appearance)
        nameTextField.setAppearance(appearance)
        amountInputView.setAppearance(appearance)
        commentTextField.setAppearance(appearance)
        saveButton.backgroundColor = appearance.colors.primaryActionBackground
        saveButton.setTitleColor(appearance.colors.primaryActionText, for: .normal)
        errorSnackbarView.setAppearance(appearance)
    }
}
