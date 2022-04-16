//
//  EditExpenseScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 24.03.2022.
//

import UIKit
import AUIKit
import PinLayout

extension EditExpenseScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let balanceAccountPickerHeaderLabel = UILabel()
    let balanceAccountPickerView = BalanceAccountHorizontalPickerView()
    let categoryPickerHeaderLabel = UILabel()
    let categoryPickerView = CategoryHorizontalPickerView()
    let dayDatePickerView = UIDatePicker()
    let amountInputView = SingleLineTextInputView()
    let commentTextField = TextField3D()
    let saveButton = TextFilledButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(balanceAccountPickerHeaderLabel)
        addSubview(balanceAccountPickerView)
        addSubview(categoryPickerHeaderLabel)
        addSubview(categoryPickerView)
        addSubview(dayDatePickerView)
        dayDatePickerView.datePickerMode = .date
        addSubview(amountInputView)
        addSubview(commentTextField)
        addSubview(saveButton)
        backgroundColor = Colors.primaryBackground
        setupBalanceAccountPickerHeaderLabel()
        setupCategoryPickerView()
        setupSaveButton()
        autoLayout()
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
    
    private func setupCategoryPickerView() {
        categoryPickerView.contentInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
    }
    
    private func setupSaveButton() {
        saveButton.backgroundColor = Colors.primaryActionBackground
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutDayDatePickerView()
    }
    
    private func autoLayoutDayDatePickerView() {
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: categoryPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    // MARK: Layout
    
    private let marginLeft: CGFloat = 24
    private let marginRight: CGFloat = 24
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBalanceAccountPickerHeaderLabel()
        layoutBalanceAccountPickerView()
        layoutCategoryPickerHeaderLabel()
        layoutCategoryPickerView()
        layoutAmountInputView()
        layoutCommentTextField()
        layoutSaveButton()
    }
    
    private func layoutBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.pin
            .left(marginLeft)
            .top(to: navigationBarView.edge.bottom).marginTop(24)
            .right(marginRight)
            .sizeToFit(.width)
    }
    
    private func layoutBalanceAccountPickerView() {
        balanceAccountPickerView.pin
            .top(to: balanceAccountPickerHeaderLabel.edge.bottom).marginTop(10)
            .left(0)
            .right(0)
            .height(30)
        balanceAccountPickerView.collectionView.contentInset = UIEdgeInsets(top: 0, left: marginLeft, bottom: 0, right: marginRight)
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
            .left(0)
            .right(0)
            .top(to: categoryPickerHeaderLabel.edge.bottom).marginTop(10)
            .height(30)
        categoryPickerView.collectionView.contentInset = UIEdgeInsets(top: 0, left: marginLeft, bottom: 0, right: marginRight)
    }
    
    private func layoutAmountInputView() {
        amountInputView.pin
            .left(marginLeft)
            .right(marginRight)
            .top(to: dayDatePickerView.edge.bottom).marginTop(24)
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
}
}
