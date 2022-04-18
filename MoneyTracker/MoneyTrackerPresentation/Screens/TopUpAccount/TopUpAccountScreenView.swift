//
//  TopUpAccountScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 05.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension TopUpAccountScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let scrollView = UIScrollView()
    let accountPickerLabel = UILabel()
    let accountPickerView = BalanceAccountHorizontalPickerView(appearance: LightAppearance())
    let dayDatePickerView = UIDatePicker()
    let amountInputView = SingleLineTextInputView(appearance: LightAppearance())
    let commentTextField = TextField3D()
    let addButton = TextFilledButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
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
        autoLayout()
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupAccountPickerLabel() {
        accountPickerLabel.font = Fonts.default(size: 14)
        accountPickerLabel.textColor = Colors.secondaryText
    }
    
    private func setupDayDatePickerView() {
        dayDatePickerView.datePickerMode = .date
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutDayDatePickerView()
    }
    
    private func autoLayoutDayDatePickerView() {
        dayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        dayDatePickerView.topAnchor.constraint(equalTo: accountPickerView.bottomAnchor, constant: 24).isActive = true
        dayDatePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutAccountPickerLabel()
        layoutAccountPickerView()
        layoutAmountInputView()
        layoutCommentTextField()
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
    
    // MARK: Keyboard
    
    private var keyboardFrame: CGRect?
    
    func setKeyboardFrame(_ keyboardFrame: CGRect?) {
        self.keyboardFrame = keyboardFrame
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
}
