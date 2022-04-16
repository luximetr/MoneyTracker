//
//  AddAccountScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

final class AddAccountScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    let scrollView = UIScrollView()
    let backgroundView = UIView()
    let nameInputView: UITextField = TextField()
    let currencyInputView = UIButton()
    let amountInputView: UITextField = TextField()
    let colorsTitleLabel = UILabel()
    let colorPickerView: ColorHorizontalPickerView
    let addButton = TextFilledButton()
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.colorPickerView = ColorHorizontalPickerView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        setupBackgroundView()
        backgroundView.addSubview(nameInputView)
        nameInputView.backgroundColor = Colors.black.withAlphaComponent(0.15)
        nameInputView.textColor = Colors.white
        nameInputView.tintColor = Colors.white
        backgroundView.addSubview(currencyInputView)
        setupCurrencyInputView()
        backgroundView.addSubview(amountInputView)
        amountInputView.backgroundColor = Colors.black.withAlphaComponent(0.15)
        amountInputView.textColor = Colors.white
        amountInputView.tintColor = Colors.white
        scrollView.addSubview(colorsTitleLabel)
        setupColorsTitleLabel()
        scrollView.addSubview(colorPickerView)
        setupColorPickerView()
        addSubview(addButton)
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.white
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.white
    }
    
    private func setupCurrencyInputView() {
        currencyInputView.backgroundColor = Colors.black.withAlphaComponent(0.15)
    }
    
    private func setupBackgroundView() {

    }
    
    private func setupColorsTitleLabel() {
        
    }
    
    private func setupColorPickerView() {
        
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutBackgroundView()
        layoutNameInputView()
        layoutCurrencyInputView()
        layoutAmountInputView()
        layoutColorsTitleLabel()
        layoutColorPickerView()
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
    
    private func layoutBackgroundView() {
        let x: CGFloat = 26
        let y: CGFloat = 26
        let width = bounds.width - 2 * x
        let height: CGFloat = 174
        let frame = CGRect(x: x, y: y, width: width, height: height)
        backgroundView.frame = frame
        backgroundView.layer.cornerRadius = 10
    }
    
    private func layoutNameInputView() {
        let x: CGFloat = 20
        let y: CGFloat = 20
        let width = backgroundView.bounds.width - 2 * x
        let height: CGFloat = 46
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameInputView.frame = frame
    }
    
    private func layoutCurrencyInputView() {
        let width: CGFloat = 44
        let height: CGFloat = 44
        let x: CGFloat = backgroundView.bounds.width - 20 - width
        let y: CGFloat = nameInputView.frame.origin.y + nameInputView.frame.size.height + 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        currencyInputView.frame = frame
        currencyInputView.layer.cornerRadius = 22
    }
    
    private func layoutAmountInputView() {
        let x: CGFloat = 20
        let y: CGFloat = nameInputView.frame.origin.y + nameInputView.frame.size.height + 20
        let width = backgroundView.bounds.width - x - (backgroundView.frame.size.width - currencyInputView.frame.origin.x) - 14
        let height: CGFloat = 46
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountInputView.frame = frame
    }
    
    private func layoutColorsTitleLabel() {
        let x: CGFloat = 26
        let y = backgroundView.frame.origin.y + backgroundView.frame.size.height + 20
        let width = bounds.width - 2 * x
        let sizeThatFits = colorsTitleLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let height = sizeThatFits.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        colorsTitleLabel.frame = frame
    }
    
    private func layoutColorPickerView() {
        let x: CGFloat = 0
        let y = colorsTitleLabel.frame.origin.y + colorsTitleLabel.frame.size.height + 8
        let width = bounds.width - 2 * x
        let height: CGFloat = 36
        let frame = CGRect(x: x, y: y, width: width, height: height)
        colorPickerView.frame = frame
    }
    
    private func setScrollViewContentSize() {
        let width = scrollView.bounds.width
        let height = colorPickerView.frame.origin.y + colorPickerView.frame.size.height + 8 + safeAreaInsets.bottom
        let contentSize = CGSize(width: width, height: height)
        scrollView.contentSize = contentSize
    }
    
    private func layoutAddButton() {
        let x: CGFloat = 44
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let y = bounds.height - 16 - height - safeAreaInsets.bottom
        var frame = CGRect(x: x, y: y, width: width, height: height)
        if let keyboardFrame = keyboardFrame {
            frame.origin.y -= keyboardFrame.size.height
        }
        addButton.frame = frame
    }
    
    // MARK: - Keyboard
    
    var keyboardFrame: CGRect?
    
    func setKeyboardFrame(_ keyboardFrame: CGRect?) {
        self.keyboardFrame = keyboardFrame
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - BackgroundColor
    
    func setBackgroundColor(_ backgroundColor: UIColor, animated: Bool) {
        backgroundView.backgroundColor = backgroundColor
    }
    
}
