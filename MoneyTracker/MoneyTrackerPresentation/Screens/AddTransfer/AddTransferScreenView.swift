//
//  TransferScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 05.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension AddTransferScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.fromAccountPickerView = BalanceAccountHorizontalPickerView(appearance: appearance)
        self.toAccountPickerView = BalanceAccountHorizontalPickerView(appearance: appearance)
        self.dayDatePickerView = DateHorizontalPickerView(appearance: appearance)
        self.fromAmountInputView = SingleLineTextInputView(appearance: appearance)
        self.toAmountInputView = SingleLineTextInputView(appearance: appearance)
        self.commentTextField = PlainTextField(appearance: appearance)
        self.addButton = TextFilledButton(appearance: appearance)
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let scrollView = UIScrollView()
    let fromAccountPickerLabel = UILabel()
    let fromAccountPickerView: BalanceAccountHorizontalPickerView
    let toAccountPickerLabel = UILabel()
    let toAccountPickerView: BalanceAccountHorizontalPickerView
    let dayDatePickerView: DateHorizontalPickerView
    let fromAmountInputView: SingleLineTextInputView
    let toAmountInputView: SingleLineTextInputView
    let commentTextField: PlainTextField
    let addButton: TextFilledButton
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        addSubview(scrollView)
        setupScrollView()
        scrollView.addSubview(fromAccountPickerLabel)
        setupFromAccountPickerLabel()
        scrollView.addSubview(fromAccountPickerView)
        scrollView.addSubview(toAccountPickerLabel)
        setupToAccountPickerLabel()
        scrollView.addSubview(toAccountPickerView)
        scrollView.addSubview(dayDatePickerView)
        scrollView.addSubview(fromAmountInputView)
        scrollView.addSubview(toAmountInputView)
        scrollView.addSubview(commentTextField)
        addSubview(addButton)
        addSubview(errorSnackbarView)
        setupAddButton()
        autoLayout()
        changeAppearance(appearance)
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupFromAccountPickerLabel() {
        fromAccountPickerLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
        fromAccountPickerLabel.textColor = appearance.colors.secondaryText
    }
    
    private func setupToAccountPickerLabel() {
        toAccountPickerLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
        toAccountPickerLabel.textColor = appearance.colors.secondaryText
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = appearance.colors.primaryActionBackground
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutDayDatePickerView()
    }
    
    private func autoLayoutDayDatePickerView() {
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: toAccountPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        dayDatePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        dayDatePickerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    // MARK: Layout
    
    private var needDisplayToAmountInputView: Bool = true
    func displayToAmountInputView(_ need: Bool) {
        self.needDisplayToAmountInputView = need
        layoutFromAmountInputView()
        layoutToAmountInputView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutFromAccountPickerLabel()
        layoutFromAccountPickerView()
        layoutToAccountPickerLabel()
        layoutToAccountPickerView()
        layoutFromAmountInputView()
        layoutCommentTextField()
        layoutToAmountInputView()
        layoutAddButton()
        layoutErrorSnackbarView()
        setScrollViewContentSize()
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
    
    private func layoutFromAccountPickerLabel() {
        let x: CGFloat = 26
        let y: CGFloat = 32
        var width = bounds.width - 2 * x
        var height = bounds.height
        let size = fromAccountPickerLabel.sizeThatFits(CGSize(width: width, height: height))
        width = size.width
        height = size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAccountPickerLabel.frame = frame
    }
    
    private func layoutFromAccountPickerView() {
        let x: CGFloat = 0
        let y = fromAccountPickerLabel.frame.origin.y + fromAccountPickerLabel.frame.size.height + 10
        let width = bounds.width - 2 * x
        let height: CGFloat = 26
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAccountPickerView.frame = frame
        fromAccountPickerView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }
    
    private func layoutToAccountPickerLabel() {
        let x: CGFloat = 26
        let y: CGFloat = fromAccountPickerView.frame.origin.y + fromAccountPickerView.frame.size.height + 18
        var width = bounds.width - 2 * x
        var height = bounds.height
        let size = toAccountPickerLabel.sizeThatFits(CGSize(width: width, height: height))
        width = size.width
        height = size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAccountPickerLabel.frame = frame
    }

    private func layoutToAccountPickerView() {
        let x: CGFloat = 0
        let y = toAccountPickerLabel.frame.origin.y + toAccountPickerLabel.frame.size.height + 10
        let width = bounds.width - 2 * x
        let height: CGFloat = 26
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAccountPickerView.frame = frame
        toAccountPickerView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }

    private func layoutFromAmountInputView() {
        if needDisplayToAmountInputView {
            let x: CGFloat = 26
            let y = dayDatePickerView.frame.origin.y + dayDatePickerView.frame.size.height + 10
            let width = (bounds.width * 0.5) - x - x * 0.5
            let height: CGFloat = 44
            let frame = CGRect(x: x, y: y, width: width, height: height)
            fromAmountInputView.frame = frame
        } else {
            let x: CGFloat = 26
            let y = dayDatePickerView.frame.origin.y + dayDatePickerView.frame.size.height + 10
            let width = bounds.width - 2 * x
            let height: CGFloat = 44
            let frame = CGRect(x: x, y: y, width: width, height: height)
            fromAmountInputView.frame = frame
        }
    }
    
    private func layoutToAmountInputView() {
        if needDisplayToAmountInputView {
            let x = fromAmountInputView.frame.maxX + 26
            let y = dayDatePickerView.frame.maxY + 10
            let width = fromAmountInputView.frame.size.width
            let height = fromAmountInputView.frame.size.height
            let frame = CGRect(x: x, y: y, width: width, height: height)
            toAmountInputView.frame = frame
        } else {
            toAmountInputView.frame = .zero
        }
    }
    
    private func layoutCommentTextField() {
        let x: CGFloat = 26
        let y = fromAmountInputView.frame.maxY + 16
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
        let width: CGFloat = 150
        let x: CGFloat = (bounds.width - width) / 2
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
        backgroundColor = appearance.colors.primaryBackground
        fromAccountPickerLabel.textColor = appearance.colors.secondaryText
        fromAccountPickerView.changeAppearance(appearance)
        dayDatePickerView.changeAppearance(appearance)
        fromAmountInputView.changeAppearance(appearance)
        toAccountPickerLabel.textColor = appearance.colors.secondaryText
        toAccountPickerView.changeAppearance(appearance)
        toAmountInputView.changeAppearance(appearance)
        commentTextField.changeAppearance(appearance)
        dayDatePickerView.overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
        addButton.backgroundColor = appearance.colors.primaryActionBackground
        addButton.setTitleColor(appearance.colors.primaryActionText, for: .normal)
        errorSnackbarView.changeAppearance(appearance)
    }
    
}
}
