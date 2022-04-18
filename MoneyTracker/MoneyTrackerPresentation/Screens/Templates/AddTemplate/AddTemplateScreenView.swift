//
//  AddTemplateScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import UIKit
import AUIKit
import PinLayout

final class AddTemplateScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let nameTextField: PlainTextField
    let amountInputView: SingleLineTextInputView
    let commentTextField: PlainTextField
    let balanceAccountPickerHeaderLabel = UILabel()
    let balanceAccountPickerView = BalanceAccountHorizontalPickerView()
    let categoryPickerHeaderLabel = UILabel()
    let categoryPickerView: CategoryHorizontalPickerView
    let addButton = TextFilledButton()
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        nameTextField = PlainTextField(appearance: appearance)
        amountInputView = SingleLineTextInputView(appearance: appearance)
        commentTextField = PlainTextField(appearance: appearance)
        categoryPickerView = CategoryHorizontalPickerView(appearance: appearance)
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
        addSubview(addButton)
        setupBalanceAccountPickerHeaderLabel()
        setupCategoryPickerView()
        changeAppearance(appearance)
    }
    
    private func setupBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.font = Fonts.default(size: 17, weight: .regular)
        balanceAccountPickerHeaderLabel.numberOfLines = 1
    }
    
    private func setupCategoryPickerView() {
        categoryPickerView.contentInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
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
        layoutAddButton()
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
    
    private func layoutAddButton() {
        addButton.pin
            .hCenter()
            .bottom(pin.safeArea).marginBottom(24)
            .width(150)
            .height(44)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        statusBarView.backgroundColor = appearance.primaryBackground
        navigationBarView.backgroundColor = appearance.primaryBackground
        balanceAccountPickerHeaderLabel.textColor = appearance.secondaryText
        categoryPickerHeaderLabel.textColor = appearance.secondaryText
        addButton.backgroundColor = appearance.primaryActionBackground
        addButton.titleLabel?.textColor = appearance.primaryActionText
    }
}
