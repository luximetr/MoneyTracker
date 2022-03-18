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
    
    let balanceAccountPickerHeaderLabel = UILabel()
    let balanceAccountPickerView = BalanceAccountHorizontalPickerView()
    let categoryPickerHeaderLabel = UILabel()
    let categoryPickerView = CategoryHorizontalPickerView()
    let nameTextField = AddExpenseScreenViewController.CommentTextField()
    let amountInputView = SingleLineTextInputView()
    let commentTextField = AddExpenseScreenViewController.CommentTextField()
    let addButton = TextFilledButton()
    
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
    
    private func setupBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.font = Fonts.default(size: 17, weight: .regular)
        balanceAccountPickerHeaderLabel.textColor = Colors.primaryText
        balanceAccountPickerHeaderLabel.numberOfLines = 1
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = Colors.primaryActionBackground
    }
    
    // MARK: - Layout
    
    private let marginLeft: CGFloat = 24
    private let marginRight: CGFloat = 24
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBalanceAccountPickerHeaderLabel()
        layoutBalanceAccountPickerView()
        layoutCategoryPickerHeaderLabel()
        layoutCategoryPickerView()
        layoutNameTextField()
        layoutAmountInputView()
        layoutCommentTextField()
        layoutAddButton()
    }
    
    private func layoutBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.pin
            .left(marginLeft)
            .top(to: navigationBarView.edge.bottom).marginTop(20)
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
            .top(to: balanceAccountPickerView.edge.bottom).marginTop(32)
            .sizeToFit(.width)
    }
    
    private func layoutCategoryPickerView() {
        categoryPickerView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: categoryPickerHeaderLabel.edge.bottom).marginTop(10)
            .height(24)
    }
    
    private func layoutNameTextField() {
        nameTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: categoryPickerView.edge.bottom).marginTop(24)
            .height(44)
    }
    
    private func layoutAmountInputView() {
        amountInputView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: nameTextField.edge.bottom).marginTop(24)
            .height(44)
    }
    
    private func layoutCommentTextField() {
        commentTextField.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: amountInputView.edge.bottom).marginTop(30)
            .height(44)
    }
    
    private func layoutAddButton() {
        addButton.pin
            .hCenter()
            .bottom(pin.safeArea).marginBottom(24)
            .width(150)
            .height(44)
    }
}
