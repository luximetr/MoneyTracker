//
//  AddAccountScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

extension AddAccountScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.colorPickerView = ColorHorizontalPickerView(appearance: appearance)
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        self.nameInputView = PlainTextField(appearance: appearance)
        self.amountInputView = PlainTextField(appearance: appearance)
        self.addButton = TextFilledButton(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let scrollView = UIScrollView()
    let backgroundView = UIView()
    let nameInputView: PlainTextField
    let currencyInputView = UIButton()
    let amountInputView: PlainTextField
    let colorsTitleLabel = UILabel()
    let colorPickerView: ColorHorizontalPickerView
    let addButton: TextFilledButton
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        setupBackgroundView()
        backgroundView.addSubview(nameInputView)
        nameInputView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        nameInputView.textColor = appearance.colors.cardPrimaryText
        nameInputView.tintColor = appearance.colors.cardPrimaryText
        nameInputView.layer.borderColor = UIColor.clear.cgColor
        backgroundView.addSubview(currencyInputView)
        setupCurrencyInputView()
        backgroundView.addSubview(amountInputView)
        amountInputView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        amountInputView.textColor = appearance.colors.cardPrimaryText
        amountInputView.tintColor = appearance.colors.cardPrimaryText
        amountInputView.layer.borderColor = UIColor.clear.cgColor
        scrollView.addSubview(colorsTitleLabel)
        setupColorsTitleLabel()
        scrollView.addSubview(colorPickerView)
        setupColorPickerView()
        addSubview(addButton)
        addSubview(errorSnackbarView)
    }
    
    private func setupCurrencyInputView() {
        currencyInputView.titleLabel?.font = appearance.fonts.primary(size: 14, weight: .semibold)
        currencyInputView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
    }
    
    private func setupBackgroundView() {

    }
    
    private func setupColorsTitleLabel() {
        colorsTitleLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupColorPickerView() {
        colorPickerView.contentInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
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
        layoutErrorSnackbarView()
    }
    
    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
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
    
    // MARK: - BackgroundColor
    
    func setBackgroundColor(_ backgroundColor: UIColor, animated: Bool) {
        backgroundView.backgroundColor = backgroundColor
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        colorsTitleLabel.textColor = appearance.colors.primaryText
        currencyInputView.setTitleColor(appearance.colors.secondaryText, for: .normal)
    }
    
}
}
