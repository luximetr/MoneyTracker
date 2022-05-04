//
//  EditReplenishmentScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.05.2022.
//

import UIKit
import AUIKit
import PinLayout

extension EditReplenishmentScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.accountPickerView = BalanceAccountHorizontalPickerView(appearance: appearance)
        self.amountInputView = SingleLineTextInputView(appearance: appearance)
        self.commentTextField = PlainTextField(appearance: appearance)
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let scrollView = UIScrollView()
    let accountPickerLabel = UILabel()
    let accountPickerView: BalanceAccountHorizontalPickerView
    let dayDatePickerView = UIDatePicker()
    let amountInputView : SingleLineTextInputView
    let commentTextField: PlainTextField
    let addButton = TextFilledButton()
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        addSubview(scrollView)
        setupScrollView()
        scrollView.addSubview(accountPickerLabel)
        setupAccountPickerLabel()
        scrollView.addSubview(accountPickerView)
        scrollView.addSubview(dayDatePickerView)
        setupDayDatePickerView()
        scrollView.addSubview(amountInputView)
        scrollView.addSubview(commentTextField)
        addSubview(addButton)
        setupAddButton()
        addSubview(errorSnackbarView)
        autoLayout()
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupAccountPickerLabel() {
        accountPickerLabel.font = Fonts.default(size: 14)
        accountPickerLabel.textColor = appearance.secondaryText
    }
    
    private func setupDayDatePickerView() {
        dayDatePickerView.overrideUserInterfaceStyle = dayDatePickerView.overrideUserInterfaceStyle
        dayDatePickerView.datePickerMode = .date
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = appearance.primaryActionBackground
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutDayDatePickerView()
    }
    
    private func autoLayoutDayDatePickerView() {
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: accountPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26).isActive = true
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutAccountPickerLabel()
        layoutAccountPickerView()
        layoutAmountInputView()
        layoutCommentTextField()
        setScrollViewContentSize()
        layoutAddButton()
        layoutErrorSnackbarView()
    }
    
    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        var frame = CGRect(x: x, y: y, width: width, height: height)
        if let keyboardFrame = keyboardFrame {
            frame.size.height -= keyboardFrame.size.height
        }
        scrollView.frame = frame
    }
    
    private func layoutAccountPickerLabel() {
        let x: CGFloat = 26
        let y: CGFloat = 32
        var width = bounds.width - 2 * x
        var height = bounds.height
        let size = accountPickerLabel.sizeThatFits(CGSize(width: width, height: height))
        width = size.width
        height = size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountPickerLabel.frame = frame
    }
    
    private func layoutAccountPickerView() {
        let x: CGFloat = 0
        let y = accountPickerLabel.frame.origin.y + accountPickerLabel.frame.size.height + 10
        let width = bounds.width - 2 * x
        let height: CGFloat = 26
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountPickerView.frame = frame
        accountPickerView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }

    private func layoutAmountInputView() {
        let x: CGFloat = 26
        let y = dayDatePickerView.frame.origin.y + dayDatePickerView.frame.size.height + 10
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountInputView.frame = frame
    }
    
    private func layoutCommentTextField() {
        let x: CGFloat = 26
        let y = amountInputView.frame.maxY + 16
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        commentTextField.frame = frame
    }
    
    private func setScrollViewContentSize() {
        let width = scrollView.bounds.width
        let height = commentTextField.frame.maxY + 32.0 + safeAreaInsets.bottom
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
    
    // MARK: Keyboard
    
    private var keyboardFrame: CGRect?
    
    func setKeyboardFrame(_ keyboardFrame: CGRect?) {
        self.keyboardFrame = keyboardFrame
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        accountPickerLabel.textColor = appearance.secondaryText
        dayDatePickerView.overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
        addButton.backgroundColor = appearance.primaryActionBackground
        errorSnackbarView.changeAppearance(appearance)
        commentTextField.changeAppearance(appearance)
        accountPickerView.changeAppearance(appearance)
        amountInputView.changeAppearance(appearance)
    }
    
}
}
