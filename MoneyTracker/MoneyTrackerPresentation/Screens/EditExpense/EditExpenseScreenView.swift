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
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.commentTextField = PlainTextField(appearance: appearance)
        self.amountInputView = SingleLineTextInputView(appearance: appearance)
        self.balanceAccountPickerView = BalanceAccountHorizontalPickerView(appearance: appearance)
        self.categoryPickerView = CategoryHorizontalPickerView(appearance: appearance)
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        self.dayDatePickerView = DateHorizontalPickerView(appearance: appearance)
        self.saveButton = TextFilledButton(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let balanceAccountPickerHeaderLabel = UILabel()
    let balanceAccountPickerView: BalanceAccountHorizontalPickerView
    let categoryPickerHeaderLabel = UILabel()
    let categoryPickerView: CategoryHorizontalPickerView
    let dayDatePickerView: DateHorizontalPickerView
    let amountInputView: SingleLineTextInputView
    let commentTextField: PlainTextField
    let saveButton: TextFilledButton
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(balanceAccountPickerHeaderLabel)
        setupBalanceAccountPickerHeaderLabel()
        addSubview(balanceAccountPickerView)
        addSubview(categoryPickerHeaderLabel)
        setupCategoryPickerHeaderLabel()
        addSubview(categoryPickerView)
        addSubview(dayDatePickerView)
        addSubview(amountInputView)
        addSubview(commentTextField)
        addSubview(saveButton)
        addSubview(errorSnackbarView)
        autoLayout()
        changeAppearance(appearance)
    }
    
    private func setupBalanceAccountPickerHeaderLabel() {
        balanceAccountPickerHeaderLabel.font = Fonts.default(size: 17, weight: .regular)
        balanceAccountPickerHeaderLabel.numberOfLines = 1
    }
    
    private func setupCategoryPickerHeaderLabel() {
        categoryPickerHeaderLabel.font = Fonts.default(size: 17, weight: .regular)
        categoryPickerHeaderLabel.numberOfLines = 1
    }
    
    // MARK: - AutoLayout
    
    private func autoLayout() {
        autoLayoutDayDatePickerView()
    }
    
    private func autoLayoutDayDatePickerView() {
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: categoryPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginLeft).isActive = true
        dayDatePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -marginRight).isActive = true
        dayDatePickerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
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
        layoutAmountInputView()
        layoutCommentTextField()
        layoutSaveButton()
        layoutErrorSnackbarView()
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
    
    private func layoutErrorSnackbarView() {
        errorSnackbarView.pin
            .left(10)
            .right(10)
            .top(to: navigationBarView.edge.top)
            .sizeToFit(.width)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        balanceAccountPickerHeaderLabel.textColor = appearance.secondaryText
        categoryPickerHeaderLabel.textColor = appearance.secondaryText
        dayDatePickerView.changeAppearance(appearance)
        amountInputView.changeAppearance(appearance)
        commentTextField.changeAppearance(appearance)
        saveButton.backgroundColor = appearance.primaryActionBackground
        saveButton.setTitleColor(appearance.primaryActionText, for: .normal)
        errorSnackbarView.changeAppearance(appearance)
    }
}
}
