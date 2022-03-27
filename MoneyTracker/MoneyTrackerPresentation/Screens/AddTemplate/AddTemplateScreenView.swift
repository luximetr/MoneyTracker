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
        backgroundColor = Colors.primaryBackground
        setupBalanceAccountPickerHeaderLabel()
        setupAddButton()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.primaryBackground
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.primaryBackground
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
    
    // MARK: - BalanceAccountPickerHeaderLabel
    
    let balanceAccountPickerHeaderLabel = UILabel()
    
    private func setupBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.font = Fonts.default(size: 17, weight: .regular)
        balanceAccountPickerHeaderLabel.textColor = Colors.primaryText
        balanceAccountPickerHeaderLabel.numberOfLines = 1
    }
    
    private func layoutBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.pin
            .left(marginLeft)
            .top(to: commentTextField.edge.bottom).marginTop(15)
            .right(marginRight)
            .sizeToFit(.width)
    }
    
    // MARK: - BalanceAccountPickerView
    
    let balanceAccountPickerView = BalanceAccountHorizontalPickerView()
    
    private func layoutBalanceAccountPickerView() {
        balanceAccountPickerView.pin
            .top(to: balanceAccountPickerHeaderLabel.edge.bottom).marginTop(10)
            .left(marginLeft)
            .right(marginRight)
            .height(30)
    }
    
    // MARK: - CategoryPickerHeaderLabel
    
    let categoryPickerHeaderLabel = UILabel()
    
    private func layoutCategoryPickerHeaderLabel() {
        categoryPickerHeaderLabel.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: balanceAccountPickerView.edge.bottom).marginTop(15)
            .sizeToFit(.width)
    }
    
    // MARK: - CategoryPickerView
    
    let categoryPickerView = CategoryHorizontalPickerView()
    
    private func layoutCategoryPickerView() {
        categoryPickerView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: categoryPickerHeaderLabel.edge.bottom).marginTop(10)
            .height(24)
    }
    
    // MARK: - NameTextField
    
    let nameTextField = CommentTextField()
    
    private func layoutNameTextField() {
        nameTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: navigationBarView.edge.bottom).marginTop(24)
            .height(44)
    }
    
    // MARK: - AmountInputView
    
    let amountInputView = SingleLineTextInputView()
    
    private func layoutAmountInputView() {
        amountInputView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: nameTextField.edge.bottom).marginTop(15)
            .height(44)
    }
    
    // MARK: - CommentTextField
    
    let commentTextField = CommentTextField()
    
    private func layoutCommentTextField() {
        commentTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: amountInputView.edge.bottom).marginTop(15)
            .height(44)
    }
    
    // MARK: - AddButton
    
    let addButton = TextFilledButton()
    
    private func setupAddButton() {
        addButton.backgroundColor = Colors.primaryActionBackground
    }
    
    private func layoutAddButton() {
        addButton.pin
            .hCenter()
            .bottom(pin.safeArea).marginBottom(24)
            .width(150)
            .height(44)
    }
}
