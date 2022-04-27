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
        self.fromAmountInputView = SingleLineTextInputView(appearance: appearance)
        self.toAmountInputView = SingleLineTextInputView(appearance: appearance)
        self.commentTextField = PlainTextField(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let scrollView = UIScrollView()
    let fromAccountPickerLabel = UILabel()
    let fromAccountPickerView: BalanceAccountHorizontalPickerView
    let toAccountPickerLabel = UILabel()
    let toAccountPickerView: BalanceAccountHorizontalPickerView
    let dayDatePickerView = UIDatePicker()
    let fromAmountInputView: SingleLineTextInputView
    let toAmountInputView: SingleLineTextInputView
    let commentTextField: PlainTextField
    let addButton = TextFilledButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        addSubview(scrollView)
        setupScrollView()
        scrollView.addSubview(fromAccountPickerLabel)
        setupFromAccountPickerLabel()
        scrollView.addSubview(fromAccountPickerView)
        scrollView.addSubview(toAccountPickerLabel)
        setupToAccountPickerLabel()
        scrollView.addSubview(toAccountPickerView)
        scrollView.addSubview(dayDatePickerView)
        setupDayDatePickerView()
        scrollView.addSubview(fromAmountInputView)
        scrollView.addSubview(toAmountInputView)
        scrollView.addSubview(commentTextField)
        addSubview(addButton)
        setupAddButton()
        autoLayout()
        changeAppearance(appearance)
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupFromAccountPickerLabel() {
        fromAccountPickerLabel.font = Fonts.default(size: 14)
        fromAccountPickerLabel.textColor = appearance.secondaryText
    }
    
    private func setupToAccountPickerLabel() {
        toAccountPickerLabel.font = Fonts.default(size: 14)
        toAccountPickerLabel.textColor = appearance.secondaryText
    }
    
    private func setupDayDatePickerView() {
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
        dayDatePickerView.overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: toAccountPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
    }
    
    // MARK: Layout
    
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
        let x: CGFloat = 26
        let y = dayDatePickerView.frame.origin.y + dayDatePickerView.frame.size.height + 10
        let width = (bounds.width * 0.5) - x - x * 0.5
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAmountInputView.frame = frame
    }
    
    private func layoutToAmountInputView() {
        let x = fromAmountInputView.frame.maxX + 26
        let y = dayDatePickerView.frame.maxY + 10
        let width = fromAmountInputView.frame.size.width
        let height = fromAmountInputView.frame.size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAmountInputView.frame = frame
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
        fromAccountPickerLabel.textColor = appearance.secondaryText
        toAccountPickerLabel.textColor = appearance.secondaryText
        dayDatePickerView.overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
        addButton.backgroundColor = appearance.primaryActionBackground
        addButton.setTitleColor(appearance.primaryActionText, for: .normal)
    }
    
}
}
